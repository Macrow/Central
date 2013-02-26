# -*- encoding : utf-8 -*-
class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :content
      t.boolean :read, default: false
      t.integer :user_id

      t.timestamps
    end
    
    add_index :notifications, :user_id
  end
end
