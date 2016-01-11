require 'gosu'

class StarVaders < Gosu::Window
  def initialize
    super 800, 600
    self.caption = 'May the force be with you...'
    @image = Gosu::Image.new 'vader.png'
    @x = 200
    @y = 200
    @width = 48
    @height = 48
  end

  def draw
    @image.draw(@x - @width / 2, @y - @height / 2, 1)
  end
end

window = StarVaders.new
window.show
