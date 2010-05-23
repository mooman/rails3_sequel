Class.new(Sequel::Migration) do
  def up
    create_table :<%= table_name %> do
<% if options[:autoincrement] then -%>
      primary_key :id
<% end -%>

<% for a in attributes do -%>
      <%= a.create_definition %>
<% end -%>
<% if options[:timestamps] then -%>
      DateTime :created_at
      DateTime :updated_at
<% end -%>
      <%= cpk %>
    end
  end

  def down
    drop_table :<%= table_name %>
  end
end
