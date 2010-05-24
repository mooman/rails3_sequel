module Rails
  module Sequel
    module Logging
      def log_duration (duration, message)
        @controller_runtime ||= 0
        @controller_runtime += duration
        ActiveSupport::Notifications.instrument('sequel.sql', 
          :sql => message,
          :name => 'SQL',
          :duration => duration * 1000
        )
        super
      end

      def log_each (level, message)
        # Rails logging is handled by the log subscriber
        less_rails = @loggers - [Rails.logger]
        less_rails.each { |logger| logger.send(level, message) }
      end

      def reset_runtime
        rt, @controller_runtime = @controller_runtime, 0
        rt.to_f * 1000
      end
    end
  end
end
