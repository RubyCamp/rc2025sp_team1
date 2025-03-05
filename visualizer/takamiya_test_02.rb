require 'gosu'

Checkpoints ={
    a: [133, 300],
    b: [267, 167],
    c: [400, 450],
    d: [533, 167],
    e: [667, 300]
  }

class Player
  attr_reader :x, :y, :next_dest
  def initialize
    @x = 700  # 初期X座標（右上からスタート）
    @y = 90  # 初期Y座標
    #@speed = 0.2 # 移動速度
    @image = Gosu::Image.new("images/kani.png", tileable: false)
    @next_dest = [@x, @y]
    @vel_per_frame_x = 0
    @vel_per_frame_y = 0
  end
  
  def update_dest(frame, checkpoint)
    # 目標座標ー現在座標/所要フレーム数
    @next_dest = checkpoint
    distance = [(@next_dest[0]-@x).abs, (@next_dest[1]-@y).abs]
    if @next_dest[0] < @x
      @vel_per_frame_x = -(distance[0].to_f/frame)
    else 
      @vel_per_frame_x = distance[0].to_f/frame
    end  
    if @next_dest[1] < @y
      @vel_per_frame_y = -(distance[1].to_f/frame)
    else
      @vel_per_frame_y = distance[1].to_f/frame
    end
  end

  def update
    @x += @vel_per_frame_x # X座標を減らして左へ移動
    @y += @vel_per_frame_y # Y座標を増やして下へ移動
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
    @course = [:e, :d, :b, :a, :c]
  end

  def update
    p Gosu.milliseconds
    if [0,2000,4000,6000,8000,10000].include?(Gosu.fps)
      p 1000
    #(@player.x.to_i >= @player.next_dest[0]-1 || @player.x.to_i <= @player.next_dest[0]+1) &&
    #(@player.y.to_i >= @player.next_dest[1]-1 || @player.y.to_i <= @player.next_dest[1]+1)
    #if @player.next_dest == [@player.x.to_i, @player.y.to_i] # 目的地に到着したら
      @player.update_dest(100, Checkpoints[@course.shift]) # 次の目的地を設定 
    end
    @player.update
    #if Gosu.milliseconds < @e_time
    #@player.update
    #elsif Gosu.milliseconds < @d_time
    #@player.updateD
    #elsif Gosu.milliseconds < @b_time
    #@player.updateB
    #elsif Gosu.milliseconds < @a_time
    #@player.updateA
    #elsif Gosu.milliseconds < @c_time
    #@player.updateC
    #elsif Gosu.milliseconds < @goal_time
    #@player.updateGoal
    #end
  end

  def draw
    @player.draw
  end
end

MyWindow.new.show