wlan = WLAN.new('STA')
wlan.connect("RubyCamp", "shimanekko")

loop do
  if wlan.connected?
    HTTP.get( "http://127.0.0.1/xxx?yyy=zzz&aaa=bbb") # 入力例：http://localhost:3000/position?op=&x=133&y=300&target=Kani1
  end
  sleep 5
end
