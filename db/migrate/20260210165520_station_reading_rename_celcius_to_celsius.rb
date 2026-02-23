class StationReadingRenameCelciusToCelsius < ActiveRecord::Migration[8.0]
  def change
    rename_column :station_readings, :celcius_temp, :celsius_temp
  end
end
