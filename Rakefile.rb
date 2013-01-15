#
# Setup
#

$LOAD_PATH.unshift 'lib'

def command?(command)
  system("type #{command} > /dev/null 2>&1")
end

#
# Tests
#

require 'rake/testtask'

task :default => :test

if command?(:rg)
  desc "Run the test suite with rg"
  task :test do
    Dir['lib/test/**/*.test.rb'].each do |f|
      sh("rg #{f}")
    end
  end
else
  Rake::TestTask.new do |test|
    test.libs << "test"
    test.test_files = FileList['lib/test/**/*.test.rb']
  end
end

if command? :kicker
  desc "Launch Kicker (like autotest)"
  task :kicker do
    puts "Kicking... (ctrl+c to cancel)"
    exec "kicker -e rake"
  end
end
