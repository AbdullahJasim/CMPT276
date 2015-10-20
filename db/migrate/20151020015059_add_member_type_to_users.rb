class AddMemberTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :memberType, :string
  end
end
