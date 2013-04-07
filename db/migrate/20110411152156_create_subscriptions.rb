class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :access_level
      t.references :system, :user, :null => false
      t.timestamps
    end
    add_index :subscriptions, [ :user_id, :system_id ], :name => "user_id_system_id"
  end

  def self.down
    drop_table :subscriptions
  end
end
