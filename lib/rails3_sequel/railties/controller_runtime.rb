module Rails
  module Sequel
    module Railties

      module ControllerRuntime
        extend ActiveSupport::Concern

        protected

        attr_internal :db_runtime

        def cleanup_view_runtime
          db_rt_before_render = ::Sequel::Model.db.reset_runtime
          runtime = super
          db_rt_after_render = ::Sequel::Model.db.reset_runtime
          self.db_runtime = db_rt_before_render + db_rt_after_render
          runtime - db_rt_after_render
        end

        def append_info_to_payload (payload)
          super
          payload[:db_runtime] = db_runtime
        end

        module ClassMethods
          def log_process_action (payload)
            messages, db_runtime = super, payload[:db_runtime]
            messages << ("DB: %.1fms" % db_runtime.to_f) if db_runtime
            messages
          end
        end

      end
    end
  end
end
