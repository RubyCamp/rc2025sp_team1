require 'gosu'

class Player
  attr_reader :x, :y

  def initialize
    @x = 720  # 初期X座標（右上からスタート）
    @y = 90  # 初期Y座標
    @speed = 1 # 移動速度
    @image = Gosu::Image.new("images/kani.png", tileable: false)
  end

  def update
    @x -= @speed  # X座標を減らして左へ移動
    @y += @speed  # Y座標を増やして下へ移動

    # 画面外に出たら反対側にワープ（640x480の画面サイズを想定）
    @x = 640 if @x < 0
    @y = 0 if @y > 480
  end

  def draw
    @image.draw(@x, @y, 0)
  end
end

class MyWindow < Gosu::Window
  def initialize
    super 800, 600
    self.caption = 'RubyCamp2025SP tutorial'
    @player = Player.new
    @start_time = Gosu.milliseconds  # ゲーム開始時刻を記録
    @e_time = 2000 # 2秒後にゲーム終了
  end

  def update
    if Gosu.milliseconds - @start_time < @e_time
    @player.update

  end

  def draw
    @player.draw
  end
end

MyWindow.new.show