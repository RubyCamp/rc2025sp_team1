class linetrace
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
end