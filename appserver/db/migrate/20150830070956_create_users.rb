class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|  
      t.string :user_id, null: false
      t.string :token, null: false
      t.string :email
      t.string :expires_at 

      t.timestamps
    end

    add_index :users, :user_id
    add_index :users, :token
    add_index :users, :expires_at     
  end
end
