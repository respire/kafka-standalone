require 'fileutils'

CWD = File.dirname(__FILE__)
EYE_LOG_PATH = File.expand_path('logs/eye.log', CWD)
FileUtils.touch EYE_LOG_PATH

Eye.config { logger EYE_LOG_PATH, 'daily', 134_217_728 }

Eye.application('kafka') do
  working_dir CWD

  group('standalone') do
    chain grace: 5.seconds
    process(:zookeeper) do
      start_command 'bin/zookeeper-server-start.sh config/zookeeper.properties'
      pid_file 'tmp/pids/zookeeper.pid'
      stdall 'logs/zookeeper.log'
      daemonize true
      stop_signals [:TERM, 1.minute, :KILL]
    end
    process(:broker) do
      start_command 'bin/kafka-server-start.sh config/server.properties'
      pid_file 'tmp/pids/broker.pid'
      stdall 'logs/broker.log'
      daemonize true
      depend_on [:zookeeper]
      stop_signals [:TERM, 15.minutes, :KILL]
    end
    process(:maxwell) do
      working_dir File.expand_path('maxwell', CWD)
      start_command 'bin/maxwell --config config.properties'
      pid_file '../tmp/pids/maxwell.pid'
      stdall '../logs/maxwell.log'
      daemonize true
      depend_on [:broker]
      stop_signals [:TERM, 5.minutes, :KILL]
    end
  end
end
