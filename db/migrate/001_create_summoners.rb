class CreateSummoners < ActiveRecord::Migration[5.2]
    def change
        create_table :summoners do |t|
            t.string :name
        end
    end
end