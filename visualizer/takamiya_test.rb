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
  d: 6000,
  b: 9000,
  a: 12000,
  c: 15000,
  goal: 18000
}

class Player
  attr_reader :x, :y

  def initialize
    @x = 700  
    @y = 90   
    @x_speed = 0
    @y_speed = 0
    @target = nil
    @image1 = Gosu::Image.new("images/kani.png", tileable: false)
    @image2 = Gosu::Image.new("images/kani2.png", tileable: false)
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
      @cx, @cy = center
      @x_speed = 0
      @y_speed = 0
      @target = nil
    end
  end

  def draw
    @image1.draw(@x - @cx, @y - @cy, 1)
  end
end

class MyWindow < Gosu::Window
  def initialize
    super 800, 600
    self.caption = 'RubyCamp2025SP tutorial'
    @player = Player.new
    @image = Gosu::Image.new("images/field.png", tileable: false)
    @waypoints = [:e, :d, :b, :a, :c, :goal]
    @current_waypoint = 0
    @player.move_to(Checkpoints[@waypoints[@current_waypoint]], MoveTimes[@waypoints[@current_waypoint]])
  end

  def update
    @player.update

    # 誤差を許容して目的地到達判定
    target_x, target_y = Checkpoints[@waypoints[@current_waypoint]]
    if (@player.x - target_x).abs < 1 && (@player.y - target_y).abs < 1
      @current_waypoint += 1 if @current_waypoint < @waypoints.length - 1
      @player.move_to(Checkpoints[@waypoints[@current_waypoint]], MoveTimes[@waypoints[@current_waypoint]])
    end
  end

  def draw
    @player.draw
    @image.draw(0, 0, 0)
  end
end

MyWindow.new.show