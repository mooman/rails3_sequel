module Rails
  module Sequel
    module Benchmarking
      def execute (sql, args=nil, &block)
        result = nil
        @runtime ||= 0
        @runtime += Benchmark.ms { result = super(sql, args, &block) }
        return result
      end

      def reset_runtime
        rt, @runtime = @runtime, 0
        rt.to_f
      end
    end
  end
end
