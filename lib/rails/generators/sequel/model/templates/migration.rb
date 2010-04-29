class <%= migration_class_name %> < Sequel::Migration
  def up
    create_table :<%= table_name %> do
      primary_key :id

<% for a in attributes do -%>
      <%= a.type %> :<%= a.name %>
<% end -%>

<% if options[:timestamps] then -%>
      DateTime :created_at
      DateTime :updated_at
<% end -%>
    end
  end

  def down
    drop_table :<%= table_name %>
  end
end
