class AddAttachmentIconToStages < ActiveRecord::Migration
  def self.up
    change_table :stages do |t|
      t.attachment :icon
    end
  end

  def self.down
    drop_attached_file :stages, :icon
  end
end
