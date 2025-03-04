wlan = WLAN.new('STA')
wlan.connect("アクセスポイント名", "パスフレーズ")

loop do
  if wlan.connected?
    HTTP.get( "http://127.0.0.1/xxx?yyy=zzz&aaa=bbb")
  end
  sleep 5
end
