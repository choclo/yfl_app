class CreateSystemMessageStatusTable < ActiveRecord::Migration
	def self.up
		create_table :system_message_status do |t|
			t.integer		:user_id
			t.ìnteger		:message_id
			t.boolean		:visible
			t.timestamps
		end
		
		add_index :system_message_status, :user_id
	end

	def self.down
		drop_table :system_message_status
	end
end
