# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      
      # authentication
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :auth_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      
      # omniauth
      t.string :provider
      t.string :uid
      
      # avatar
      t.string :avatar
      
      # basic information
      t.string :sex
      t.date :birthday
      t.string :location
      t.string :sign
      t.string :home_url
      t.string :description
      
      # track information
      t.string :register_ip
      t.string :last_login_ip
      t.datetime :last_login_at
      t.datetime :last_activity_at
      t.datetime :last_activity_count_at
      t.integer :activity_count, default: 0
      
      # score
      t.integer :score, default: 0
      
      # admin
      t.boolean :admin, default: false

      t.timestamps
    end
    
    add_index :users, [:name, :email], unique: true
    add_index :users, :auth_token, unique: true
    add_index :users, [:provider, :uid]

    create_table :relationships do |t|
      t.integer :watching_id
      t.integer :watcher_id
    end
    
    add_index :relationships, [:watching_id]
    add_index :relationships, [:watcher_id]
  end
end
