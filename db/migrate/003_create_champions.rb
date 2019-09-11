class CreateChampions < ActiveRecord::Migration[5.2]
    def change
        create_table :champions do |t|
            t.integer :champ_id
            t.string :name
        end
    end
end