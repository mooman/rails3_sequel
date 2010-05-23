Class.new(Sequel::Migration) do
  def up
    Sequel::Model.db.alter_table :<%= table_name %> do
<% for a in attributes do -%>
      <%= migration_action %>_column :<%= a.name %><% if migration_action == 'add' %>, <%= a.alter_definition %><% end %>
<% end -%>
    end
  end

  def down
    Sequel::Model.db.alter_table :<%= table_name %> do
<% for a in attributes.reverse do -%>
      <%= migration_action == 'add' ? 'drop' : 'add' %>_column :<%= a.name %><% if migration_action == 'drop' %>, <%= a.alter_definition %><% end %>
<% end -%>
    end
  end
end
