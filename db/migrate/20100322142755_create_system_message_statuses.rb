class CreateSystemMessageStatuses < ActiveRecord::Migration
  def self.up
    create_table :system_message_statuses do |t|
			t.integer		:user_id
			t.string		:message_id
			t.boolean		:visible
      t.timestamps
    end
  end

  def self.down
    drop_table :system_message_statuses
  end
end
