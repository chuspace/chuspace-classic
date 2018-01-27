class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :name
      t.string :timezone
      t.string :country

      t.timestamps
    end
  end
end
