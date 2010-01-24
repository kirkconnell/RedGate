class CreateMeasurements < ActiveRecord::Migration
  def self.up
    create_table :measurements do |t|
      t.string :gate_name
      t.integer :message_id
      t.datetime :sended_at

      t.timestamps
    end
  end

  def self.down
    drop_table :measurements
  end
end
