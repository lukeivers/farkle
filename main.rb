require './player'
require './single_ones_player'
require './dice'

$debug = false

@player1 = Player.new
@player2 = Player.new
@player1_games = 0
@player2_games = 0
@games_count = 0
@num_games = 300
while @games_count < @num_games
  @winning_player = nil
  @playing = true
  @current_player = @player2
  @other_player = @player1
  last_chance = false
  if $debug
    puts 'Starting game'
  end
  while @playing do
    if $debug
      puts "@player1_score: #{@player1.score}, @player2_score: #{@player2.score}"
    end
    dice = Dice.new
    dice.roll
    farkled = false
    while not dice.farkle? and not @current_player.banked? do
      if dice.farkle?
        farkled = true
        next
      end
      @current_player.choose(dice)
      if $debug
        puts "@current_player temp_score: #{@current_player.temp_score}"
      end
      if @current_player.banked?
        next
      end
      if $debug
        puts "rolling"
      end
      dice.roll
      if dice.farkle?
        farkled = true
      end
    end
    if @current_player.banked?
      if $debug
        puts "@current_player banked #{@current_player.temp_score}"
      end
      @current_player.score += @current_player.temp_score
    end
    if farkled
      if $debug
        puts "@current_player farkled"
      end
    end
    @current_player.temp_score = 0
    @current_player.banked = false
    if last_chance
      if @player1.score > @player2.score
        if $debug
          puts "player1 wins with #{@player1.score}.  player2 score was #{@player2.score}"
        end
        @winning_player = @player1
      else
        if $debug
          puts "player2 wins with #{@player2.score}.  player2 score was #{@player1.score}"
        end
        @winning_player = @player2
      end
      @playing = false
    end
    if @current_player.score > 10000
      last_chance = true
      if $debug
        puts 'LAST CHANCE!!!'
      end
    end
    temp = @current_player
    @current_player = @other_player
    @other_player = temp
  end
  @player1.score = 0
  @player2.score = 0
  if @winning_player == @player1
    @player1_games += 1
  else
    @player2_games += 1
  end
  @games_count += 1
end

puts "player1 percentage: #{@player1_games.to_f/@num_games.to_f*100}, \
player2 percentage: #{@player2_games.to_f/@num_games.to_f*100}"
