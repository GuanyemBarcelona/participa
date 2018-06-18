class AddTypeAmountToCollaborations < ActiveRecord::Migration
  def change
    add_column :collaborations, :type_amount, :string
  end
end
