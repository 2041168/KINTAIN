class CreateYoteis < ActiveRecord::Migration[7.0]
  def change
    create_table :yoteis do |t|
      t.time :yoteikaishi
      t.time :yoteiowari

      t.timestamps
    end
  end
end
