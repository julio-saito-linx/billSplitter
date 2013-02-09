require 'logger'

class SimpleLogger
  attr_accessor :log

  def initialize(output, level)
    $log = Logger.new(output)
    $log.level = level
  end
end

# usage:
# SimpleLogger.new(STDOUT, Logger::ERROR)
# $log.info("some log info")
