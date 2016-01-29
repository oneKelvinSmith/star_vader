require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'lazer'

class StarVaders < Gosu::Window
  WIDTH = 800
  HEIGHT = 600
  ENEMY_FREQUENCY = 0.05

  def initialize
    super WIDTH, HEIGHT
    self.caption = 'May the force be with you...'
    @player = Player.new(self)
    @enemies = []
    @lazers = []
  end

  def draw
    @player.draw
    @enemies.each(&:draw)
    @lazers.each(&:draw)
  end

  def update
    @player.turn_left if button_down? Gosu::KbLeft
    @player.turn_right if button_down? Gosu::KbRight
    @player.accelerate if button_down? Gosu::KbUp
    @player.move
    @enemies.push Enemy.new(self) if rand < ENEMY_FREQUENCY
    @enemies.each(&:move)
    @lazers.each(&:move)
    @enemies.dup.each do |enemy|
      @lazers.dup.each do |lazer|
        distance = Gosu.distance(enemy.x, enemy.y, lazer.x, lazer.y)
        if distance < enemy.radius + lazer.radius
          @enemies.delete enemy
          @lazers.delete lazer
        end
      end
    end
  end

  def button_down(key)
    if key == Gosu::KbSpace
      @lazers.push Lazer.new(self, @player.x, @player.y, @player.angle)
    end
  end
end

window = StarVaders.new
window.show
