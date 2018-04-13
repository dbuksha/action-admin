module ActionAdmin
  module Form
    module Uploadable
      extend ActiveSupport::Concern

      class_methods do
        def multiupload_field(name)
          attr_name = :"#{name}"
          attr_curr = :"current_#{name}"
          attr_prev = :"#{name}_was"

          define_method attr_curr do
            instance_variable_get("@#{attr_curr}") || []
          end

          define_method :"#{attr_curr}=" do |new_value|
            instance_variable_set("@#{attr_curr}", new_value || [])
          end

          after_initialize do |record|
            current = record.send(attr_name)

            if current
              current = current.map { |i| i.file.file }
              record.send :"#{attr_curr}=", current.uniq
            end
          end

          before_validation do |record|
            curr_files = Array(record.send(attr_curr)).reject(&:blank?)
            keep_files = record.send(attr_prev).select do |item|
              item.file.file.in? curr_files
            end

            if send(:"#{attr_name}_cache").present?
              new_files = record.send(attr_name)
              all_files = keep_files + new_files
            else
              all_files = keep_files
            end

            record.send :"#{attr_name}=", all_files.uniq { |i| i.file.file }
          end
        end
      end
    end
  end
end