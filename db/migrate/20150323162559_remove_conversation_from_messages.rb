class RemoveConversationFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :conversation_id
  end
end
