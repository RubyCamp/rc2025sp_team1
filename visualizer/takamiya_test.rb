require 'gosu'

Checkpoints ={
    a: [133, 300],
    b: [267, 167],
    c: [400, 450],
    d: [533, 167],
    e: [667, 300],
    goal: [400,600]
  }

class Player
  attr_reader :x, :y
  attr_accessor :x_speed, :y_speed

  def initialize
    @x = 700  # 初期X座標（右上からスタート）
    @y = 90  # 初期Y座標
    @x_speed = 1 # 移動速度
    @y_speed = 1 # 移動速度
    @image = Gosu::Image.new("images/kani.png", tileable: false)
  end

  def move(checkpoint)
    # 目標座標ー現在座標/所要フレーム数
    @next_dest = checkpoint
    if checkpoint[0] < @x
      @x -= @x_speed # X座標を減らして左へ移動
    else 
      @x += @x_speed # X座標を増やして右へ移動
    end  
    if checkpoint[1] < @y
      @y -= @y_speed # Y座標を減らして上へ移動
    else
      @y += @y_speed # Y座標を増やして下へ移動
    end
  end
  def draw
    @image.draw(@x-50, @y-50, 1)
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
    @image = Gosu::Image.new("images/field.png", tileable: false)
  end

  def update
    if Gosu.milliseconds < @e_time
    @player.move(Checkpoints[:e])
    @player.x_speed = 1
    @player.y_speed = 4
    elsif Gosu.milliseconds < @d_time
    @player.x_speed = 1
    @player.y_speed = 1
    @player.move(Checkpoints[:d])
    elsif Gosu.milliseconds < @b_time
    @player.x_speed = 2
    @player.y_speed = 0
    @player.move(Checkpoints[:b])
    elsif Gosu.milliseconds < @a_time
    @player.x_speed = 2
    @player.y_speed = 2
    @player.move(Checkpoints[:a])
    elsif Gosu.milliseconds < @c_time
    @player.x_speed = 2
    @player.y_speed = 2
    @player.move(Checkpoints[:c])
    elsif Gosu.milliseconds < @goal_time
    @player.x_speed = 2
    @player.y_speed = 2
    @player.move(Checkpoints[:goal])
    end
  end

  def draw
    @player.draw
    @image.draw(0, 0, 0)
  end
end

MyWindow.new.show