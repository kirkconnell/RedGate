class RenameSendedAtToSentAt < ActiveRecord::Migration
  def self.up
    rename_column :measurements, :sended_at, :sent_at
  end

  def self.down
    rename_column :measurements, :sent_at, :sended_at
  end
end
