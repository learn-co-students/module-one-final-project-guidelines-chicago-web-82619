class CreateChampions < ActiveRecord::Migration[5.2]
    def change
        create_table :champions, id: false do |t|
            t.primary_key :champ_id
            t.string :name
        end
    end
end