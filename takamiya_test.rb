require 'gosu'

class Player
  attr_reader :x, :y

  def initialize
    @x = 700  # 初期X座標（右上からスタート）
    @y = 90  # 初期Y座標
    @speed = 1 # 移動速度
    @image = Gosu::Image.new("images/kani.png", tileable: false)
  end

  def updateE
    @x -= @speed  # X座標を減らして左へ移動
    @y += @speed  # Y座標を増やして下へ移動

  def updateD
    @x -= @speed  # X座標を減らして左へ移動
    @y -= @speed  # Y座標を減らして上へ移動
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
    @e_time = 2000 # 2秒後にE地点
    @d_time = 4000 # 4秒後にD地点
    @b_time = 6000 # 6秒後にB地点
    @a_time = 8000 # 8秒後にA地点
    @c_time = 10000 # 10秒後にC地点
    @goal_time = 12000 # 12秒後にゴール
  end

  def update
    if Gosu.milliseconds < @e_time
    @player.updateE
    elsif Gosu.milliseconds < @d_time
    @player.updateD
    elsif Gosu.milliseconds < @b_time
    @player.updateB
    elsif Gosu.milliseconds < @a_time
    @player.updateA
    elsif Gosu.milliseconds < @c_time
    @player.updateC
    elsif Gosu.milliseconds < @goal_time
    @player.updateGoal
    else
  end

  def draw
    @player.draw
  end
end

MyWindow.new.show
end