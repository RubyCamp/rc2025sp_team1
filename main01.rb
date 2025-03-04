   # 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
   rm_pin1 = PWM.new(25) # 右モーターPIN1
   rm_pin2 = PWM.new(26) # 右モーターPIN2
   
   # 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
   lm_pin1 = PWM.new(32) # 左モーターPIN1
   lm_pin2 = PWM.new(33) # 左モーターPIN2
   
   lux_right = ADC.new(35) # 右ライトセンサー初期化（GPIO番号: 35）
   lux_left  = ADC.new(2)  # 左ライトセンサー初期化（GPIO番号: 2）
   
   
   
   while true
           if (lux_right.read_raw <= 100)
           # 左右モーター逆転
           lm_pin1.duty(0)
           lm_pin2.duty(100)
           rm_pin1.duty(0)
           rm_pin2.duty(100)
           sleep 0.3
           # 回転
           lm_pin1.duty(0)
           lm_pin2.duty(100)
           rm_pin1.duty(100)
           rm_pin2.duty(0)
           sleep 0.3
           elsif (lux_left.read_raw <= 100)
           # 左右モーター逆転
           lm_pin1.duty(0)
           lm_pin2.duty(100)
           rm_pin1.duty(0)
           rm_pin2.duty(100)
           sleep 0.3
           # 回転
           lm_pin1.duty(100)
           lm_pin2.duty(0)
           rm_pin1.duty(0)
           rm_pin2.duty(100)
           sleep 0.3
       end
       
       # 左右モーター出力30%正回転
       lm_pin1.duty(30)
       lm_pin2.duty(00)
       rm_pin1.duty(30)
       rm_pin2.duty(0)
       sleep (0.1)
   end