   # 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
   @rm_pin1 = PWM.new(25) # 右モーターPIN1
   @rm_pin2 = PWM.new(26) # 右モーターPIN2
   
   # 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
   @lm_pin1 = PWM.new(32) # 左モーターPIN1
   @lm_pin2 = PWM.new(33) # 左モーターPIN2
   
   lux_right = ADC.new(35) # 右ライトセンサー初期化（GPIO番号: 35）
   lux_left  = ADC.new(2)  # 左ライトセンサー初期化（GPIO番号: 2）

def kanimove(t,lmpin1,lmpin2,rmpin1,rmpin2) #(秒数*0.2,左モーターpin1,左モーターpin2,右モーターpin1,右モーターpin2)
    i = 0
    t.times do
        @lm_pin1.duty(lmpin1)
        @lm_pin2.duty(lmpin2)
        @rm_pin1.duty(rmpin1)
        @rm_pin2.duty(rmpin2)
        sleep 0.2
        i += 0.2
    end
    puts "#{i} 秒間移動しました"
end

def kanirotate(t,r,l)#(秒数*0.2,右回転強さ,左回転強さ)
    i = 0
    t.times do
        @lm_pin1.duty(r)
        @lm_pin2.duty(l)
        @rm_pin1.duty(l)
        @rm_pin2.duty(r)
        sleep 0.2
        i += 0.2
    end
    if r >= l
        puts "#{i} 秒間右回転しました"
    end
    elsif r <= l
        puts "#{i} 秒間左回転しました"
    end
end

def brake
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
end

#移動
kanimove(10,40,0,40,0)

#回転
kanirotate(4,40,0)

#移動
kanimove(9,40,0,40,0)

#ブレーキ
brake