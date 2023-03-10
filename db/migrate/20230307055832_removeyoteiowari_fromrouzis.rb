class RemoveyoteiowariFromrouzis < ActiveRecord::Migration[7.0]
  def change
    remove_column :rouzis, :yoteiowari, :time
  end
end
