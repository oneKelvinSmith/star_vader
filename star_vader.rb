require 'gosu'
require_relative 'player'

class StarVaders < Gosu::Window
  def initialize
    super 800, 600
    self.caption = 'May the force be with you...'
    @player = Player.new(self)
  end


  def draw
    @player.draw
  end
end

window = StarVaders.new
window.show
