module Workhorse
  class Daemon::ShellHandler
    def self.run(*args, &block)
      unless ARGV.count == 1
        usage
        exit 99
      end

      daemon = Workhorse::Daemon.new(*args, &block)

      begin
        case ARGV.first
        when 'start'
          daemon.start
        when 'stop'
          daemon.stop
        when 'status'
          daemon.status
        when 'watch'
          daemon.watch
        when 'restart'
          daemon.restart
        when 'usage'
          usage
          exit 99
        else
          usage
        end

        exit 0
      rescue => e
        warn "#{e.message}\n#{e.backtrace.join("\n")}"
        exit 99
      end
    end

    def usage
      warn <<~USAGE
        Usage: #{$PROGRAM_NAME} start|stop|status|watch|restart|usage

        Exit status:
         0  if OK,
         1  if at least one worker has an unexpected status,
         99 on all other errors.
      USAGE
    end
  end
end
