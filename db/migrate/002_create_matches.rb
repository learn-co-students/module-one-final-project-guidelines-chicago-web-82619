class CreateMatches <ActiveRecord::Migration[5.2]
    def change
        create_table :matches do |t|
            t.integer :summoner_id
            t.integer :champion_id
            t.integer :game_id
            t.integer :ban
            t.boolean :win
        end
    end
end