class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :gate_name
      t.string :uri

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
