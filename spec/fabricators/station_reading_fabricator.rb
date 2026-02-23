Fabricator(:station_reading) do
  celsius_temp { 0 }
  relative_humidity { 100 }
  recorded_on { Time.now }
end
