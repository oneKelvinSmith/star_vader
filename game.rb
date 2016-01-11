require 'gosu'

class Window < Gosu::Window
  def initialize
    super 800, 600
    self.caption = 'Hello Game World!'
  end
end

window = Window.new
window.show
