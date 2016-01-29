class Explosion
  def initialize(window, x, y)
    @x = x
    @y = y
    @radius = 30
    @window = window
    @images = Gosu::Image.load_tiles 'images/explosions.png', 64, 64
    @image_index = 0
    @done = false
  end

  def draw
    if @image_index < @images.count
      @images[@image_index].draw @x - @radius, @y - @radius, 2
      @image_index += 1
    else
      @done = true
    end
  end

  def finished?
    @done
  end
end
