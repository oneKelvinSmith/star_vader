require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'lazer'
require_relative 'explosion'
require_relative 'credit'

class StarVader < Gosu::Window
  WIDTH = 800
  HEIGHT = 600
  ENEMY_FREQUENCY = 0.03
  MAX_ENEMIES = 100

  def initialize
    super WIDTH, HEIGHT
    self.caption = 'May the force be with you...'
    @scene = :start
    @background_image = Gosu::Image.new('images/start.png')
    @start_music      = Gosu::Song.new('sounds/black_vortex.mp3')
    @start_music.play true
  end

  def initialize_game
    @scene = :game
    @background_image = Gosu::Image.new('images/background.png')
    @game_music       = Gosu::Song.new('sounds/phantom_from_space.mp3')
    @game_music.play true

    @explosion_sound = Gosu::Sample.new('sounds/explosion.mp3')
    @lazer_sound     = Gosu::Sample.new('sounds/tie_lazer.wav')

    @player      = Player.new(self)
    @enemies     = []
    @lazers      = []
    @explosions  = []
    @enemies_appeared  = 0
    @enemies_destroyed = 0
  end

  def initialize_end(fate)
    @scene = :end
    @background_image = Gosu::Image.new('images/end.png')
    @game_music       = Gosu::Song.new('sounds/despair_and_triumph.mp3')
    @game_music.play true

    case fate
    when :count_reached
      @message = "You vanquished #{@enemies_destroyed} rebels!"
      escaped = (MAX_ENEMIES - @enemies_destroyed)
      @message2 = "but... #{escaped} escaped your clutches."
    when :hit_by_enemy
      @message = 'The rebel scum collided with your vessel.'
      @message2 = "You ended #{@enemies_destroyed} rebels before this fate."
    when :out_of_bounds
      @message = 'You fled the battle in preparation of your revenge.'
      @message2 = "You vanquished #{@enemies_destroyed} rebels anyway."
    end
    @bottom_message = "Press 'p' to play again, or 'q' to quit."
    @message_font = Gosu::Font.new(28, name: 'Star Jedi')
    @credits = []
    y = 700
    File.open('credits.txt').each do |line|
      @credits.push Credit.new(self, line.chomp, 100, y)
      y += 30
    end
  end

  def draw
    case @scene
    when :start
      draw_start
    when :game
      draw_game
    when :end
      draw_end
    end
  end

  def draw_start
    @background_image.draw 0, 0, 0
  end

  def draw_game
    @background_image.draw 0, 0, 0
    @player.draw
    @enemies.each(&:draw)
    @lazers.each(&:draw)
    @explosions.each(&:draw)
  end

  def draw_end
    @background_image.draw 0, 0, 0
    clip_to(50, 140, 700, 360) do
      @credits.each(&:draw)
    end
    draw_line 0, 140, Gosu::Color::RED, WIDTH, 140, Gosu::Color::RED
    @message_font.draw @message, 40, 40, 1, 1, 1, Gosu::Color::YELLOW
    @message_font.draw @message2, 40, 75, 1, 1, 1, Gosu::Color::YELLOW
    draw_line 0, 500, Gosu::Color::RED, WIDTH, 500, Gosu::Color::RED
    @message_font.draw @bottom_message, 180, 540, 1, 1, 1, Gosu::Color::WHITE
  end

  def update
    case @scene
    when :game
      update_game
    when :end
      update_end
    end
  end

  def update_game
    @player.turn_left  if button_down? Gosu::KbLeft
    @player.turn_right if button_down? Gosu::KbRight
    @player.accelerate if button_down? Gosu::KbUp
    @player.move
    if rand < ENEMY_FREQUENCY
      @enemies.push Enemy.new(self)
      @enemies_appeared += 1
    end
    @enemies.each(&:move)
    @lazers.each(&:move)
    @enemies.dup.each do |enemy|
      @lazers.dup.each do |lazer|
        distance = Gosu.distance(enemy.x, enemy.y, lazer.x, lazer.y)
        if distance < enemy.radius + lazer.radius
          @enemies.delete enemy
          @lazers.delete lazer
          @explosions.push Explosion.new(self, enemy.x, enemy.y)
          @explosion_sound.play
          @enemies_destroyed += 1
        end
      end
    end
    @enemies.dup.each do |enemy|
      @enemies.delete enemy if enemy.y > HEIGHT + enemy.radius
    end
    @explosions.dup.each do |explosion|
      @explosions.delete explosion if explosion.finished?
    end
    @lazers.dup.each do |lazer|
      @lazers.delete lazer unless lazer.onscreen?
    end
    initialize_end(:count_reached) if @enemies_appeared > MAX_ENEMIES
    @enemies.each do |enemy|
      distance = Gosu.distance enemy.x, enemy.y, @player.x, @player.y
      initialize_end(:hit_by_enemy) if distance < @player.radius + enemy.radius
    end
    initialize_end(:out_of_bounds) if @player.y < -@player.radius
  end

  def update_end
    @credits.each(&:move)
    @credits.each(&:reset) if @credits.last.y < 150
  end

  def button_down(key)
    case @scene
    when :start
      button_down_start(key)
    when :game
      button_down_game(key)
    when :end
      button_down_end(key)
    end
  end

  def button_down_start(_key)
    initialize_game
  end

  def button_down_game(key)
    if key == Gosu::KbSpace
      @lazers.push Lazer.new(self, @player.x, @player.y, @player.angle)
      @lazer_sound.play
    end
  end

  def button_down_end(key)
    case key
    when Gosu::KbQ
      close
    when Gosu::KbP
      initialize_game
    end
  end
end

window = StarVader.new
window.show
