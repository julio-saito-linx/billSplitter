  Delim = '|'.freeze unless defined?(Delim)
  EMPTY = ''.freeze unless defined?(EMPTY)
  UNKNOWN = 'UNKNOWN_MODULE'.freeze unless defined?(UNKNOWN)
  
  class Logger
    # global logger for this module's namespace
    
    @hsh = { :nc => Util::InternalLogger::Null,
      :lc => Util::InternalLogger::LiveFile,
      :filename => "/usr/orc/log/debug-#{Time.now.strftime("%Y%m%d")}.txt"
    }

    Instance = Adapter::LogAdapter.new
    Instance.build(@hsh)
    Instance.wire
    #Instance.make_live

    class << self
      attr_accessor :module_name
      
      def log(level, message)
        Instance.log(level, (module_name || UNKNOWN) + Delim + message)
      end

      def make_live
        Instance.make_live
      end

      def make_null
        Instance.make_null
      end
      
      def open(filename)
        Instance.open(filename)
      end

      %w(debug info warn error fatal).each do |method_name|
        class_eval <<-code
        def #{method_name}(message)
          log("#{method_name}".to_sym, message)
        end
        code
      end
    end
  end