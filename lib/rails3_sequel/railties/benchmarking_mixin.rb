module Rails
  module Sequel
    module Benchmarking
      def execute (sql, opts={}, &block)
        result = nil
        @runtime ||= 0
        ActiveSupport::Notifications.instrument('sequel.sql', :sql => sql, :name => 'SQL') do
          @runtime += Benchmark.ms { result = super(sql, opts, &block) }
        end
        return result
      end

      def reset_runtime
        rt, @runtime = @runtime, 0
        rt.to_f
      end
    end
  end
end
