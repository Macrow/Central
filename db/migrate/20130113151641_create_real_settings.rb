# -*- encoding : utf-8 -*-
class CreateRealSettings < ActiveRecord::Migration
  def self.up
    create_table :settings, :force => true do |t|
      t.string  :key, :null => false
      t.text    :value
      t.integer :target_id
      t.string  :target_type
      t.timestamps
    end

    add_index :settings, [ :target_type, :target_id, :key ], :unique => true
  end

  def self.down
    drop_table :settings
  end
end
