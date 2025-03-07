
@wlan = WLAN.new('STA')
@wlan.connect("RubyCamp","shimanekko")

if @wlan.connected?
    puts "Wi-Fiに接続しました"
else
    puts "Wi-Fi接続に失敗しました"
    exit
end

# 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
@rm_pin1 = PWM.new(25,timer:0,channel:1) # 右モーターPIN1
@rm_pin2 = PWM.new(26,timer:0,channel:2) # 右モーターPIN2

# 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
@lm_pin1 = PWM.new(32,timer:1,channel:3) # 左モーターPIN1
@lm_pin2 = PWM.new(33,timer:1,channel:4) # 左モーターPIN2

@lux_right = ADC.new(35) # 右ライトセンサー初期化（GPIO番号: 35）
@lux_left  = ADC.new(2)  # 左ライトセンサー初期化（GPIO番号: 2）

@i2c = I2C.new()             # I2Cシリアルインターフェース初期化
@vl53l0x = VL53L0X.new(@i2c)  # 距離センサー（VL53L0X）
@vl53l0x.set_timeout(500)    # タイムアウト値設定（単位: ms）
@range = 10000 #ボールとの距離

@ball_hold = 0 #ボールを持っているか 0は持ってない 1は持ってる

@http_switch = 0

@servo = PWM.new(27, timer:2, channel:5, frequency:50) # 周波数は 50 に．timer と channel はオプション
puts "サーボを0度に設定しました。"

def kanimove(t) 
    @lm_pin1.duty(100)
    @lm_pin2.duty(71)
    @rm_pin1.duty(99)
    @rm_pin2.duty(73)
    sleep t
    puts "#{t} 秒間移動しました"
    @range = @vl53l0x.read_range_continuous_millimeters
    puts @range
    puts "TIMED OUT" if @vl53l0x.timeout_occurred
    if @range <= 90
        @servo.pulse_width_us(2000) # 90度に設定
        puts "サーボが90度になりました"
        @ball_hold = 1
        if @http_switch == 0
            if @wlan.connected?
                HTTP.get("http://192.168.6.88:3000/value?value=false")
                @http_switch = 1
            end
        end
    end
    brake()
end

#kanirotate
@r = 0
@l = 1
def kanirotate(t, rl) # (秒数*0.2,右=0 左=1)
    if rl == 0 
        @lm_pin1.duty(100)
        @lm_pin2.duty(75)
        @rm_pin1.duty(0)
        @rm_pin2.duty(0)
        sleep t
        puts "#{t} 秒間右回転しました"
        brake()
elsif
        @lm_pin1.duty(0)
        @lm_pin2.duty(0)
        @rm_pin1.duty(100)
        @rm_pin2.duty(75)
        sleep t
        puts "#{t} 秒間左回転しました"
        brake()
    end
    @range = @vl53l0x.read_range_continuous_millimeters
    puts @range
    puts "TIMED OUT" if @vl53l0x.timeout_occurred
    if @range <= 90
        @servo.pulse_width_us(2000) # 90度に設定
        puts "サーボが90度になりました"
        @ball_hold = 1
        if @http_switch == 0
            if @wlan.connected?
                HTTP.get("http://192.168.6.88:3000/value?value=false")
                @http_switch = 1
            end
        end
    end
end

def brake
    @lm_pin1.duty(50)
    @lm_pin2.duty(50)
    @rm_pin1.duty(50)
    @rm_pin2.duty(50)
    puts "ブレーキを掛けました"
    sleep 0.1
end

if !@vl53l0x.init
    puts "initialize failed"
else
    @vl53l0x.start_continuous(100) # 100ms 間隔で計測する（タイムアウトより小さい値にしておくこと）
end

@servo.pulse_width_us(1300) # 0度に設定

kanirotate(0.1,@l)

#Eまで動く
kanimove(3.5)
kanirotate(0.1,@r)
kanirotate(0.1,@r)
kanimove(2.1)
if @ball_hold == 1 #ボールを持った場合、ゴールに一直線に突っ走る
    puts "ボールをつかみました！ゴールへ向かいます！"
    kanirotate(0.5,@r)
    @lm_pin1.duty(100)
    @lm_pin2.duty(54)
    @rm_pin1.duty(100)
    @rm_pin2.duty(50)
    sleep
end

#Dの方向を向く
7.times do
kanirotate(0.4,@r)
end
kanirotate(0.1,@l)
kanirotate(0.1,@l)
kanirotate(0.1,@r)

#Dまで移動
kanimove(3)
if @ball_hold == 1 #ボールを持った場合、ゴールに一直線に突っ走る
puts "ボールをつかみました！ゴールへ向かいます！"
kanirotate(3,@l)
    @lm_pin1.duty(100)
    @lm_pin2.duty(60)
    @rm_pin1.duty(100)
    @rm_pin2.duty(54)
    sleep
end

#回転、Bの方向を向く
4.times do
    kanirotate(0.2,@l)
end
#Bまで移動
4.times do
    kanimove(1)
end
kanirotate(0.2,@l)
kanirotate(0.2,@l)
kanirotate(0.2,@l)
kanirotate(0.2,@l)
kanimove(1)
kanirotate(0.18,@l)
kanimove(1)
if @ball_hold == 1 #ボールを持った場合、ゴールに一直線に突っ走る
puts "ボールをつかみました！ゴールへ向かいます！"
kanirotate(1.5,@l)
    @lm_pin1.duty(100)
    @lm_pin2.duty(55)
    @rm_pin1.duty(100)
    @rm_pin2.duty(60)
    sleep
end

#回転、Aの方向を向く
kanirotate(0.8,@l)

#Aまで移動
kanimove(3)
kanimove(3)

if @ball_hold == 1 #ボールを持った場合、ゴールに一直線に突っ走る
puts "ボールをつかみました！ゴールへ向かいます！"
kanirotate(0.1,@l)
    @lm_pin1.duty(100)
    @lm_pin2.duty(55)
    @rm_pin1.duty(100)
    @rm_pin2.duty(60)
    sleep
end
#回転、Cの方向を向く
kanirotate(3,@l)

#Cまで移動
    @lm_pin1.duty(100)
    @lm_pin2.duty(60)
    @rm_pin1.duty(100)
    @rm_pin2.duty(60)
    sleep 6


#カニをゴールへシュート！超！エキサイティング！
   loop do
           if (lux_right.read_raw <= 100 || lux_right.read_raw >= 1900)
           # 左右モーター逆転
           @lm_pin1.duty(0)
           @lm_pin2.duty(100)
           @rm_pin1.duty(0)
           @rm_pin2.duty(100)
           sleep 0.3
           # 回転
           @lm_pin1.duty(0)
           @lm_pin2.duty(100)
           @rm_pin1.duty(100)
           @rm_pin2.duty(0)
           sleep 0.3
           elsif (lux_left.read_raw <= 100 || lux_left.read_raw >= 1900)
           # 左右モーター逆転
           @lm_pin1.duty(0)
           @lm_pin2.duty(100)
           @rm_pin1.duty(0)
           @rm_pin2.duty(100)
           sleep 0.3
           # 回転
           @lm_pin1.duty(100)
           @lm_pin2.duty(0)
           @rm_pin1.duty(0)
           @rm_pin2.duty(100)
           sleep 0.3
           end
       
       # 左右モーター出力30%正回転
       @lm_pin1.duty(100)
       @lm_pin2.duty(70)
       @rm_pin1.duty(100)
       @rm_pin2.duty(70)
       sleep (0.1)
   end

	