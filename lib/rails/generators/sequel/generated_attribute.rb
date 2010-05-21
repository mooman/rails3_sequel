module Sequel
  module Generators
    class GeneratedAttribute
      attr_accessor :name, :type

      def initialize(name, type)
        @name = name
        @type = type.to_sym
      end

      def definition
        case type
          when :text then "String :#{name}, :text => true"
          when :boolean then "TrueClass :#{name}"
          else "#{type} :#{name}"
        end
      end

      def field_type
        @field_type ||= case type
          when :Integer, :Float, :BigDecimal, :FixNum, :Numeric   then :text_field
          when :DateTime, :Time                                   then :datetime_select
          when :Date                                              then :date_select
          when :String                                            then :text_field
          when :text                                              then :text_area
          when :boolean, :TrueClass, :FalseClass                  then :check_box
          else
            :text_field
        end
      end

      def default
        @default ||= case type
          when :integer                     then 1
          when :float                       then 1.5
          when :decimal                     then "9.99"
          when :datetime, :timestamp, :time then Time.now.to_s(:db)
          when :date                        then Date.today.to_s(:db)
          when :string                      then "MyString"
          when :text                        then "MyText"
          when :boolean                     then false
          else
            ""
        end
      end

      def human_name
        name.to_s.humanize
      end

      def reference?
        false
      end
    end
  end
end
