class ChangezitsukaishiTypeInRouzis < ActiveRecord::Migration[7.0]
  def change
    change_column :rouzis, :zitsukaishi, :datetime
    change_column :rouzis, :zitsuowari, :datetime
    change_column :yoteis, :yoteikaishi, :datetime
    change_column :yoteis, :yoteiowari, :datetime
  end
end
