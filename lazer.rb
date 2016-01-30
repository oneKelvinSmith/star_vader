class Lazer
  SPEED = 12

  attr_reader :x, :y, :radius

  def initialize(window, x, y, angle)
    @x = x
    @y = y
    @direction = angle
    @image = Gosu::Image.new 'images/lazer_green.png'
    @radius = 6
    @window = window
  end

  def move
    @x += Gosu.offset_x @direction, SPEED
    @y += Gosu.offset_y @direction, SPEED
  end

  def draw
    @image.draw_rot @x - @radius, @y - @radius, 1, @direction
  end

  def onscreen?
    right  = @window.width + @radius
    left   = -@radius
    top    = -@radius
    bottom = @window.height + @radius

    @x > left && @x < right && @y > top && @y < bottom
  end
end
