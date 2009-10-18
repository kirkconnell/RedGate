class AddGateNameToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :gate_name, :string
  end

  def self.down
    remove_column :messages, :gate_name
  end
end
