class CreateRouzis < ActiveRecord::Migration[7.0]
  def change
    create_table :rouzis do |t|
      t.integer :user_id
      t.time :yoteikaishi
      t.time :yoteiowari
      t.time :zitsukaishi
      t.time :zitsuowari

      t.timestamps
    end
  end
end
