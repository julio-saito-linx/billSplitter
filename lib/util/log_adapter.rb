  module Adapter
    class LogAdapter
      include Adapter

      attr_reader :events
      attr_accessor :null_class, :live_class
      attr_reader :logger

      def initialize
        @events = []
        @null_class, @live_class = Util::InternalLogger::Null, Util::InternalLogger::LiveFile
        @null_obj, @live_obj = nil, nil
        @logger = nil
      end

      def update(event)
        if event.respond_to?(:debug)
          log(:info, "Debug logging was [#{live?}], event.debug [#{event.debug}]")
          (event.debug ? make_live : make_null)
          log(:info, "Debug logging now [#{live?}]")
        end
      end

      def log(level, message)
        if live?
          @logger.log(level, message)
        else
          @live_obj.log(level, message) if [:info, :warn, :error, :fatal].include?(level)
        end
      end

      def build(options = {}) #(nc = @null_class, lc = @live_class, service = 'default', host = '172.28.55.103', port = 47990)
        begin
          @live_class = options[:lc] || @live_class
          @null_class = options[:nc] || @null_class
          @null_obj = @null_class.new

          make_directory(options)

          open(options[:filename])
        rescue Exception => e
          File.open("/tmp/new_exception", "a+") { |f| f.write("#{e}\n") }
        end
      end

      def wire
        @logger = @null_obj
      end

      def make_live
        @logger = @live_obj
        @logger.log(:debug, "LogAdapter: made live")
      end

      def make_null
        @logger = @null_obj
        @logger.log(:debug, "LogAdapter: made null")
      end
      
      def open(filename)
        # let's us open up a new file for logging
        @live_obj = @live_class.new(filename)
      end

      def live?
        @logger == @live_obj
      end

      private

      def make_directory(options)
        unless options[:filename].nil? || options[:filename].empty?
          path = File.dirname(options[:filename])
          unless File.exist?(path)
            temp = ""
            path.split(File::SEPARATOR).each do |piece|
              temp += piece + File::SEPARATOR
              Dir.mkdir(temp) unless File.exist?(temp)
            end
          end
        end
      end
    end
  end