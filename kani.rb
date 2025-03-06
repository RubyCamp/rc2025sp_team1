wlan = WLAN.new('STA')
wlan.connect("RubyCamp", "shimanekko")
@ball_hold = 1
loop do
  if wlan.connected?
    sleep 5
    HTTP.get( "http://192.168.6.88:3000/value?value=#{@ball_hold}") # 入力例：http://localhost:3000/position?op=&x=133&y=300&target=Kani1
  end
  sleep 5
end
