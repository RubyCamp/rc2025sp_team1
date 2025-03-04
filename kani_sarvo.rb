i2c = I2C.new()             # I2Cシリアルインターフェース初期化
vl53l0x = VL53L0X.new(i2c)  # 距離センサー（VL53L0X）
vl53l0x.set_timeout(500)    # タイムアウト値設定（単位: ms）

servo = PWM.new(27, timer:2, channel:3, frequency:50) # 周波数は 50 に．timer と channel はオプション
servo.pulse_width_us(2000) # 0度に設定

if !vl53l0x.init
  puts "initialize failed"
else
  vl53l0x.start_continuous(100) # 100ms 間隔で計測する（タイムアウトより小さい値にしておくこと）
  loop do
    puts vl53l0x.read_range_continuous_millimeters
    puts "TIMED OUT" if vl53l0x.timeout_occurred
    if vl53l0x.read_range_continuous_millimeters >=60
        #servo.pulse_width_us(2000) # 90度に設定
        puts "OK"
    else
        servo.pulse_width_us(2500) # 90度に設定
        puts "NO"
    end
  end
end

=begin
servo = PWM.new(27, timer:2, channel:3, frequency:50) # 周波数は 50 に．timer と channel はオプション

loop do
  servo.pulse_width_us(1000) # 0度に設定
  sleep 1
  servo.pulse_width_us(1500) # 45度に設定
  sleep 1
  servo.pulse_width_us(2000) # 90度に設定
  sleep 1
end
=end
