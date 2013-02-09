module Util
module InternalLogger
  class Base
    def log; raise NotImplementedError; end

    # since we provide a null object that drops all messages on the floor, we need a simple
    # way to inquire if the particular active instance is null or not
    def null?; raise NotImplementedError; end

    def sync; raise NotImplementedError; end
  end


  class Null < Base
    def log(level, message); nil; end

    def null?; true; end

    def sync; nil; end
  end


  class LiveFile < Base

    def initialize(filename)
      open(filename)
    end

    def open(filename)
      cleanup
      begin
        @filename = filename
        @logger = File.open(filename, "a+")
        @attempt_reconnect = false
      rescue Exception => e
        @attempt_reconnect = true
        File.open("/tmp/internal_logger_exception", "a+") { |f| f.write("#{e}\nbacktrace = \n#{e.backtrace}") }
      end
    end

    def log(level, message)
      if connected?
        begin
          @logger.write("#{Time.now}|#{level}|#{message}\n")
          @logger.fsync
        rescue Exception => e
          @attempt_reconnect = true
          File.open("/tmp/internal_logger_exception", "a+") { |f| f.write("#{e}\nbacktrace = \n#{e.backtrace}") }
        end
      end
    end

    def connected?
      if @attempt_reconnect
        begin
          @logger = File.open(@filename, "a+")
          @attempt_reconnect = false
        rescue Exception => e
          @attempt_reconnect= true
          File.open("/tmp/internal_logger_exception", "a+") { |f| f.write("#{e}\nbacktrace = \n#{e.backtrace}") }
        end
      end
      !@attempt_reconnect
    end

    def sync
      @logger.fsync
    end

    def null?; false; end

    private

    def cleanup
      # close the logger if it already has a file open
      if @logger
        begin
          @logger.close unless @logger.closed?
          @filename = nil
        rescue Exception => e
          File.open("/tmp/internal_logger_exception", "a+") { |f| f.write("#{e}\nbacktrace = \n#{e.backtrace}") }
        end
      end
    end
  end


  class LiveNetwork < Base

    def initialize(service, host, port)
      @service = service
      @host = host
      @port = port
      begin
        @logger = Swiftcore::Analogger::Client.new(@service, @host, @port)
        @attempt_reconnect = false
        puts "init, connected"
      rescue Exception => e
        @attempt_reconnect = true
        puts "init, not connected"
        File.open("/tmp/internal_logger_exception", "a+") { |f| f.write("#{e}\n") }
      end
    end

    def log(level, message)
      if connected?
        begin
          @logger.log(level, message)
        rescue Exception => e
          @attempt_reconnect = true
        end
      end
    end

    def connected?
      if @attempt_reconnect
        begin
          @logger.reconnect
          @attempt_reconnect = false
          puts "connected?, reconnected"
        rescue Exception => e
          @attempt_reconnect= true
          puts "connected?, failed"
          File.open("/tmp/internal_logger_exception", "a+") { |f| f.write("#{e}\n") }
        end
      end
      !@attempt_reconnect
    end

    def null?; false; end
  end


end
