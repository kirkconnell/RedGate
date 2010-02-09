class AddInQueueToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :in_queue, :boolean
  end

  def self.down
    remove_column :messages, :in_queue
  end
end
