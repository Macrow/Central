# -*- encoding : utf-8 -*-
class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.text :content
      t.boolean :inbox, default: false
      t.integer :sender_id
      t.integer :user_id
      t.string :receiver_ids_string
      t.boolean :read, default: false

      t.timestamps
    end
    
    add_index :messages, :user_id
    add_index :messages, [:sender_id, :user_id]
    add_index :messages, [:receiver_ids_string, :user_id]
  end
end
