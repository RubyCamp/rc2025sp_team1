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


# 左右モーター出力100%正回転
lm_pin1.duty(100)
lm_pin2.duty(0)
rm_pin1.duty(80)
rm_pin2.duty(0)

sleep 3

# Eで回転
lm_pin1.duty(100)
lm_pin2.duty(0)
rm_pin1.duty(0)
rm_pin2.duty(0)

sleep 1

# Dに向かう
lm_pin1.duty(80)
lm_pin2.duty(0)
rm_pin1.duty(100)
rm_pin2.duty(0)

sleep 3

# Bに向かう
lm_pin1.duty(100)
lm_pin2.duty(0)
rm_pin1.duty(100)
rm_pin2.duty(0)

sleep 3

#Aに向かう
lm_pin1.duty(80)
lm_pin2.duty(0)
rm_pin1.duty(100)
rm_pin2.duty(0)

sleep 3

#Cに向かう
lm_pin1.duty(80)
lm_pin2.duty(0)
rm_pin1.duty(100)
rm_pin2.duty(0)

sleep 3

#ゴール
lm_pin1.duty(100)
lm_pin2.duty(0)
rm_pin1.duty(90)
rm_pin2.duty(0)

sleep 1

# 左右モーター停止
lm_pin1.duty(100)
lm_pin2.duty(100)
rm_pin1.duty(100)
rm_pin2.duty(100)

