class <%= migration_class_name %> < Sequel::Migration
  def up
    Sequel::Model.db.alter_table :<%= table_name %> do
<% for a in attributes do -%>
      <%= migration_action %>_column :<%= a.name %><% if migration_action == 'add' %>, <%= a.type %><% end -%>
<% end -%>
    end
  end

  def down
    Sequel::Model.db.alter_table :<%= table_name %> do
<% for a in attributes.reverse do -%>
      <%= migration_action == 'add' ? 'drop' : 'add' %>_column :<%= a.name %><% if migration_action == 'remove' %>, <%= a.type %><% end -%>
<% end -%>
    end
  end
end
