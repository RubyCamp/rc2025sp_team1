require 'gosu'
require 'singleton'

require_relative 'server'

Checkpoints = {
  a: [133, 300],
  b: [267, 167],
  c: [400, 450],
  d: [533, 167],
  e: [667, 300],
  goal: [400, 600]
}

MoveTimes = {
  e: 6000,
  d: 8000,
  b: 10000,
  a: 12000,
  c: 14000,
  goal: 16000
}

class Player

  include Singleton

  attr_reader :x, :y
  attr_accessor :x, :y, :angle, :image1, :image2, :set_image, :ball_hold

  def initialize
    @x = 700  
    @y = 90   
    @x_speed = 0
    @y_speed = 0
    @target = nil
    @angle = 104.2 - 270
    @image1 = Gosu::Image.new("images/kani.png", tileable: false)
    @image2 = Gosu::Image.new("images/kani_ball.png", tileable: false)
    @set_image = @image1
    @ball_hold = true
  end

  def set_hold(value)
    @ball_hold = value
    p @ball_hold
  end

  def center
    #画像を2枚にしたタイミングでif文つける
    cx = (@image1.width / 2)
    cy = (@image1.height / 2)
    [cx, cy]
  end

  def move_to(checkpoint, duration)
    @target = checkpoint
    frames = duration / (1000.0 / 60) # 60FPS換算
    @x_speed = (@target[0] - @x) / frames
    @y_speed = (@target[1] - @y) / frames
  end

  def update
    # puts @ball_hold
    return unless @target

    @x += @x_speed
    @y += @y_speed
    @cx, @cy = center

    @cx, @cy = center

    # 目的地に到達したかチェック（厳密比較ではなく誤差を許容）
    if (@x - @target[0]).abs < 1 && (@y - @target[1]).abs < 1
      @x, @y = @target
      @cx, @cy = center
      @x_speed = 0
      @y_speed = 0
      @target = nil
      @cx, @cy = center
    end
  end

  def draw
    @set_image.draw_rot(@x, @y, 1, @angle)
  end
end

class Ball
  attr_accessor :ball_x, :ball_y, :ball_image1
  def initialize(player)
    @player = player
    @ball_x = -100
    @ball_y = -100
    @ball_image1 = Gosu::Image.new("images/ball1.png", tileable: false)
  end

  def update
    @cx, @cy = center
    if Gosu.button_down?(Gosu::KB_E)
      @ball_x = 667
      @ball_y = 300 
    end
    if Gosu.button_down?(Gosu::KB_D)
      @ball_x = 533
      @ball_y = 167 
    end
    if Gosu.button_down?(Gosu::KB_B)
      @ball_x = 267
      @ball_y = 167 
    end
    if Gosu.button_down?(Gosu::KB_A)
      @ball_x = 133
      @ball_y = 300 
    end
    if Gosu.button_down?(Gosu::KB_C)
      @ball_x = 400
      @ball_y = 450 
    end
  end

  def center
    #画像を2枚にしたタイミングでif文つける
    cx = (@ball_image1.width / 2)
    cy = (@ball_image1.height / 2)
    [cx, cy]
  end

  def draw
    @ball_image1.draw(@ball_x - @cx, @ball_y - @cy, 1)
  end
end

class Cutin
  def initialize(image, x, y)
    @image = image
    @cutin_x = x
    @cutin_y = y
    @cutin_speed = 40  # 速度
    @cuttime =80
  end

  def update
    @cutin_x += @cutin_speed if @cutin_x < 100  # 目標地点まで移動
    @cuttime -= 1
    @cutin_x += @cutin_speed if @cuttime < 0
  end

  def draw
    @image.draw(@cutin_x, @cutin_y, 10)
  end
end

class SpeedLine
  def initialize(image)
    @image = image
    @x = 0
    @speed = 350
  end

  def update
    @x += @speed
    @x = 0 if @x > 600  # ループ
  end

  def draw
    @image.draw(@x, 150, 2)
    @image.draw(@x - 800, 150, 2) # 繋ぎ目用
  end
end

class MyWindow < Gosu::Window
  attr_reader :waypoints 
  attr_accessor :waypoints, :current_waypoint
  def initialize
    super 800, 600
    self.caption = 'RubyCamp2025SP tutorial'
    @player = Player.instance
    @ball = Ball.new(@player)
    @image = Gosu::Image.new("images/field.png", tileable: false)
    @waypoints = [:e, :d, :b, :a, :c, :goal]
    @current_waypoint = 0
    @player.move_to(Checkpoints[@waypoints[@current_waypoint]], MoveTimes[@waypoints[@current_waypoint]])
    @x_angle, @y_angle = @player.x, @player.y
    @next_dest = [@x_angle, @y_angle]
    @cutin_image = Gosu::Image.new("images/cutin1.png")
    @cutin = Cutin.new(@cutin_image, -500, 150)  # 位置指定
    @show_cutin = false
    @cutin_time = 100
    @speedline_image = Gosu::Image.new("images/speedline.jpg", tileable: true)
    @speedline_bg = SpeedLine.new(@speedline_image)
  end

  def update
    @player.update
    @ball.update
    exit if Gosu.button_down?(Gosu::KB_ESCAPE)
    @cutin.update if @show_cutin

    # if @player.ball_hold == false
    if @player.x == @ball.ball_x && @player.y == @ball.ball_y
      if @cutin_time > 1
        puts "cutin_time = #{@cutin_time}"
        @show_cutin = true
        @current_waypoint = @waypoints.index(:goal) 
        @speedline_bg.update
        @cutin_time -= 1
      else
        @show_cutin = false
        @ball.ball_x = -100
        @ball.ball_y = -100
        @player.set_image = @player.image2
        @current_waypoint = @waypoints.index(:goal) 
        @current_waypoint += 1 if @current_waypoint < @waypoints.length - 1
        @player.move_to(Checkpoints[@waypoints[@current_waypoint]], MoveTimes[@waypoints[@current_waypoint]])
      end
    end

    # 誤差を許容して目的地到達判定
    target_x, target_y = Checkpoints[@waypoints[@current_waypoint]]
    if (@player.x - target_x).abs < 1 && (@player.y - target_y).abs < 1
      @player.angle = deter_angle
      @current_waypoint += 1 if @current_waypoint < @waypoints.length - 1
      @player.move_to(Checkpoints[@waypoints[@current_waypoint]], MoveTimes[@waypoints[@current_waypoint]])
    end
  end

  def deter_angle
    @angle_x, @angle_y = @x, @y
    @angle_x = @next_dest[0]
    @angle_y = @next_dest[1]
    @next_dest = Checkpoints[@waypoints[@current_waypoint + 1]]
    dx = @next_dest[0] - @angle_x
    dy = @next_dest[1] - @angle_y
    angle_rad = Math.atan2(dy, dx)
    angle_deg = angle_rad * 180 / Math::PI
    return angle_deg + 90
  end

  def draw
    @player.draw
    @ball.draw
    @image.draw(0, 0, 0)
    @cutin.draw if @show_cutin
    @speedline_bg.draw if @show_cutin
    # draw_line(@player.x - 10, @player.y, Gosu::Color::RED, @player.x + 10, @player.y, Gosu::Color::RED, 2)
    # draw_line(@player.x, @player.y - 10, Gosu::Color::RED, @player.x, @player.y + 10, Gosu::Color::RED, 2)
    # draw_line(@ball.ball_x - 10, @ball.ball_y, Gosu::Color::RED, @ball.ball_x + 10, @ball.ball_y, Gosu::Color::RED, 2)
    # draw_line(@ball.ball_x, @ball.ball_y - 10, Gosu::Color::RED, @ball.ball_x, @ball.ball_y + 10, Gosu::Color::RED, 2)
  end
end

# Webrickサーバ開始
Server.new.run

# メインウィンドウ表示
window = MyWindow.new
window.show