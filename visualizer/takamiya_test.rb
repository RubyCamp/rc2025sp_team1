require 'gosu'

Checkpoints = {
  a: [133, 300],
  b: [267, 167],
  c: [400, 450],
  d: [533, 167],
  e: [667, 300],
  goal: [400, 600]
}

MoveTimes = {
  e: 3000,
  d: 4000,
  b: 5000,
  a: 6000,
  c: 7000,
  goal: 8000
}

class Player
  attr_reader :x, :y
  attr_accessor :angle

  def initialize
    @x = 700  
    @y = 90   
    @x_speed = 0
    @y_speed = 0
    @target = nil
    @angle = 104.2 - 270
    @image1 = Gosu::Image.new("images/kani.png", tileable: false)
    # @image2 = Gosu::Image.new("images/kani2.png", tileable: false)
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
    return unless @target

    @x += @x_speed
    @y += @y_speed
    @cx, @cy = center

    # 目的地に到達したかチェック（厳密比較ではなく誤差を許容）
    if (@x - @target[0]).abs < 1 && (@y - @target[1]).abs < 1
      @x, @y = @target
      @x_speed = 0
      @y_speed = 0
      @target = nil
      @cx, @cy = center
    end
  end

  def draw
    @image1.draw_rot(@x - @cx, @y - @cy, 1, @angle)
  end
end

class MyWindow < Gosu::Window
  attr_reader :weypoints 
  def initialize
    super 800, 600
    self.caption = 'RubyCamp2025SP tutorial'
    @player = Player.new
    @image = Gosu::Image.new("images/field.png", tileable: false)
    @waypoints = [:e, :d, :b, :a, :c, :goal]
    @current_waypoint = 0
    @player.move_to(Checkpoints[@waypoints[@current_waypoint]], MoveTimes[@waypoints[@current_waypoint]])
    @x_angle, @y_angle = @player.x, @player.y
    @next_dest = [@x_angle, @y_angle]
  end

  def update
    @player.update

    # 誤差を許容して目的地到達判定
    target_x, target_y = Checkpoints[@waypoints[@current_waypoint]]
    if (@player.x - target_x).abs < 1 && (@player.y - target_y).abs < 1
      # @player.angle = deter_angle
      @current_waypoint += 1 if @current_waypoint < @waypoints.length - 1
      @player.move_to(Checkpoints[@waypoints[@current_waypoint]], MoveTimes[@waypoints[@current_waypoint]])
    end
  end

  def deter_angle
    @angle_x, @angle_y = @x, @y
    @angle_x = @next_dest[0]
    @angle_y = @next_dest[1]
    # p @waypoints
    # p @current_waypoint
    # p @waypoints[@current_waypoint]
    @next_dest = Checkpoints[@waypoints[@current_waypoint]]
    dx = @next_dest[0] - @angle_x
    dy = @next_dest[1] - @angle_y
    angle_rad = Math.atan2(dy, dx)
    angle_deg = angle_rad * 180 / Math::PI
    return angle_rad - 30
  end

  def draw
    @player.draw
    @image.draw(0, 0, 0)
    # draw_line(@player.x - 10, @player.y, Gosu::Color::RED, @player.x + 10, @player.y, Gosu::Color::RED, 2)
    # draw_line(@player.x, @player.y - 10, Gosu::Color::RED, @player.x, @player.y + 10, Gosu::Color::RED, 2)
  end
end

MyWindow.new.show