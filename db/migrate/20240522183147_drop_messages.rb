class DropMessages < ActiveRecord::Migration[7.1]
  def up
    drop_table :messages if ActiveRecord::Base.connection.table_exists? 'messages'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
