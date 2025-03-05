# 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
@rm_pin1 = PWM.new(25) # 右モーターPIN1
@rm_pin2 = PWM.new(26) # 右モーターPIN2

# 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
@lm_pin1 = PWM.new(32) # 左モーターPIN1
@lm_pin2 = PWM.new(33) # 左モーターPIN2

lux_right = ADC.new(35) # 右ライトセンサー初期化（GPIO番号: 35）
lux_left  = ADC.new(2)  # 左ライトセンサー初期化（GPIO番号: 2）

def kanimove(t) # (秒数*0.3)
    i = 0
    t.times do
        @lm_pin1.duty(30)
        @lm_pin2.duty(0)
        @rm_pin1.duty(30)
        @rm_pin2.duty(0)
        sleep 0.1
        i += 0.1
    end
    puts "#{i * 4} 秒間移動しました"
end

@r = 0
@l = 1
def kanirotate(t, rl) # (秒数*0.2,右=0 左=1)
    i = 0
    if rl == 0 
        t.times do
            @lm_pin1.duty(29)
            @lm_pin2.duty(0)
            @rm_pin1.duty(0)
            @rm_pin2.duty(30)
            i += 0.1
            sleep 0.1
        end
        puts "#{i * 2} 秒間右回転しました"
    else
        t.times do
            @lm_pin1.duty(0)
            @lm_pin2.duty(30)
            @rm_pin1.duty(30)
            @rm_pin2.duty(0)
            sleep 0.1
            i += 0.1
        end
        puts "#{i * 2} 秒間左回転しました"
    end
end

def brake
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
    puts "ブレーキを掛けました"
end

#回転
kanirotate(1, @r)

#Eまで移動
kanimove(12)

#回転、Gの方向を向く
kanirotate(6, @r)

#Gまで移動
kanimove(10)

#回転、Bの方向を向く
kanirotate(4,@l)

#Bまで移動
kanimove(10)

#回転、Aの方向を向く
kanirotate(4,@l)

#Aまで移動
kanimove(7)

#回転、Cの方向を向く
kanirotate(8,@l)

#Cまで移動
kanimove(15)

#回転、ゴールの方向を向く
kanirotate(6,@r)

#カニをゴールへシュート！超！エキサイティング！
brake