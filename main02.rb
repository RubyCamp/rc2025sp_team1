# 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
@rm_pin1 = PWM.new(25) # 右モーターPIN1
@rm_pin2 = PWM.new(26) # 右モーターPIN2

# 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
@lm_pin1 = PWM.new(32) # 左モーターPIN1
@lm_pin2 = PWM.new(33) # 左モーターPIN2

lux_right = ADC.new(35) # 右ライトセンサー初期化（GPIO番号: 35）
lux_left  = ADC.new(2)  # 左ライトセンサー初期化（GPIO番号: 2）

def kanimove(t) 
    @lm_pin1.duty(100)
    @lm_pin2.duty(71)
    @rm_pin1.duty(100)
    @rm_pin2.duty(73)
    sleep t
    puts "#{t} 秒間移動しました"
    brake()
end

#kanirotate
@r = 0
@l = 1
def kanirotate(t, rl) # (秒数*0.2,右=0 左=1)
    if rl == 0 
        @lm_pin1.duty(100)
        @lm_pin2.duty(75)
        @rm_pin1.duty(75)
        @rm_pin2.duty(100)
        sleep t
        puts "#{t} 秒間右回転しました"
        brake()
elsif
        @lm_pin1.duty(75)
        @lm_pin2.duty(100)
        @rm_pin1.duty(100)
        @rm_pin2.duty(75)
        sleep t
        puts "#{t} 秒間左回転しました"
        brake()
    end
end

def brake
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
    puts "ブレーキを掛けました"
end

    @rm_pin1.duty(100)
    @rm_pin2.duty(80)
    sleep 0.2
#回転してEの方向を向く
kanirotate(0.33,@r)

#Eまで動く
4.times do
    kanimove(3)
end
#Dの方向を向く
kanirotate(4.5,@r)
#Dまで移動
kanimove(11)
#回転、Bの方向を向く
kanirotate(0.8,@l)

#Bまで移動
5.times do
    kanimove(3)
end

#回転、Aの方向を向く
kanirotate(1.3,@l)

#Aまで移動
kanimove(18)

#回転、Cの方向を向く
kanirotate(1.5,@l)

#Cまで移動
    @lm_pin1.duty(100)
    @lm_pin2.duty(60)
    @rm_pin1.duty(100)
    @rm_pin2.duty(60)
    sleep 6

#回転、ゴールの方向を向く
kanirotate(1,@r)

#カニをゴールへシュート！超！エキサイティング！
    @lm_pin1.duty(100)
    @lm_pin2.duty(0)
    @rm_pin1.duty(100)
    @rm_pin2.duty(0)
    sleep 6
brake()
