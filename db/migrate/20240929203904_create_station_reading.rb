class CreateStationReading < ActiveRecord::Migration[7.2]
  def change
    create_table :station_readings do |t|
      t.float :celcius_temp, null: false
      t.float :relative_humidity, null: false
      t.datetime :recorded_on, null: false

      t.timestamps
    end
  end
end
