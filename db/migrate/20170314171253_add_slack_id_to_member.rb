class AddSlackIdToMember < ActiveRecord::Migration
  def change
    add_column :members, :slack_id, :string
  end
end
