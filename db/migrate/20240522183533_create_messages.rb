class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
