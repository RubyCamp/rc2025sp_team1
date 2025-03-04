i2c = I2C.new()             # I2Cシリアルインターフェース初期化
vl53l0x = VL53L0X.new(i2c)  # 距離センサー（VL53L0X）
vl53l0x.set_timeout(500)    # タイムアウト値設定（単位: ms）

if !vl53l0x.init
  puts "initialize failed"
else
  vl53l0x.start_continuous(100) # 100ms 間隔で計測する（タイムアウトより小さい値にしておくこと）
  loop do
    puts vl53l0x.read_range_continuous_millimeters
    puts "TIMED OUT" if vl53l0x.timeout_occurred
  end
end   # if !vl53l0x.init                                                                               
# End of distance_sensor.rb   