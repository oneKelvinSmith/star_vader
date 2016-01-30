class Enemy
  SPEED = 4

  attr_reader :x, :y, :radius

  def initialize(window)
    @radius = 24
    @x = rand(window.width - 2 * @radius) + @radius
    @y = 0
    @image = Gosu::Image.new 'images/x-wing.png'
  end

  def draw
    @image.draw_rot @x - @radius, @y - @radius, 1, 180
  end

  def move
    @y += SPEED
  end
end
