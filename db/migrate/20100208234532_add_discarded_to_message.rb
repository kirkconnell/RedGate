class AddDiscardedToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :discarded, :boolean
  end

  def self.down
    remove_column :messages, :discarded
  end
end
