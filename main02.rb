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
    @lm_pin2.duty(69)
    @rm_pin1.duty(100)
    @rm_pin2.duty(71)
    sleep t
    puts "#{t} 秒間移動しました"
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
elsif
        @lm_pin1.duty(75)
        @lm_pin2.duty(100)
        @rm_pin1.duty(100)
        @rm_pin2.duty(75)
        sleep t
        puts "#{t} 秒間左回転しました"
    end
end

def brake
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
    puts "ブレーキを掛けました"
end

    # @rm_pin1.duty(100)
    # @rm_pin2.duty(80)
    # sleep 0.2
        
        brake()
#回転してEの方向を向く
kanirotate(0.5,@r)

#Eまで動く
kanimove(9)

#Dの方向を向く
kanirotate(4,@r)

#Dまで移動
kanimove(8)

#回転、Bの方向を向く
kanirotate(0.7,@l)

#Bまで移動
kanimove(8)

# #回転、Aの方向を向く
# kanirotate(3,@l)

# #Aまで移動
# kanimove(7)

# #回転、Cの方向を向く
# kanirotate(8,@l)

# #Cまで移動
# kanimove(15)

# #回転、ゴールの方向を向く
# kanirotate(6,@r)

#カニをゴールへシュート！超！エキサイティング！
brake()