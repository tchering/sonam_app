class CreateMicroposts < ActiveRecord::Migration[7.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    #i will add composite index on user_id and created_at columns to sort the microposts in reverse order of creation meaning the most recent microposts will be displayed first.
    add_index:microposts, [:user_id, :created_at]
  end
end
