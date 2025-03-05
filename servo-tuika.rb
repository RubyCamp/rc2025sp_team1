# モーターの回転制御
# モーター毎のPIN1・PIN2にそれぞれ電圧を掛け、その差によって回転が変化する。
# 電圧の強さは、周波数とduty比（パルスの立ち上がり比率）の数値によってコントロール可能。
# 
# 蟹ロボのモーターは以下の仕様で制御できる。
# 
# PIN1: high, PIN2: low  #=> 正回転
# PIN1: low,  PIN2: high #=> 逆回転
# PIN1: high, PIN2: high #=> ブレーキ
# PIN1: low,  PIN2: low  #=> low-power automatic sleep mode

# 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
rm_pin1 = PWM.new(25) # 右モーターPIN1
rm_pin2 = PWM.new(26) # 右モーターPIN2

# 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
lm_pin1 = PWM.new(32) # 左モーターPIN1
lm_pin2 = PWM.new(33) # 左モーターPIN2


# 左右モーター出力30%正回転
lm_pin1.duty(30)
lm_pin2.duty(00)
rm_pin1.duty(30)
rm_pin2.duty(0)

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
sleep 3 # 3秒間待機

# 左右モーター出力100%正回転
lm_pin1.duty(100)
lm_pin2.duty(0)
rm_pin1.duty(100)
rm_pin2.duty(0)

sleep 3 # 3秒間待機

# 左右モーター停止
lm_pin1.duty(100)
lm_pin2.duty(100)
rm_pin1.duty(100)
rm_pin2.duty(100)
=end