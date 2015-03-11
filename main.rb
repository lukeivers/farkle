require './player'
require './single_ones_player'
require './dice'
require './strategies'
require 'pp'
require 'benchmark'

$debug = false

all_single_strategies = Strategy.all_single
temp_strategy_matrix = (1..all_single_strategies.size).flat_map do |n|
  all_single_strategies.combination(n).to_a
end
strategy_matrix = []
temp_strategy_matrix.each do |strategy|
  strategy_matrix << Strategy.new(strategy)
end
Strategy.all_multiple.each do |ary|
  ary.each do |item|
    new_strategies = []
    strategy_matrix.each do |strategy|
      new_strategy = strategy.dup
      new_strategy << item
      new_strategies << new_strategy
    end
    strategy_matrix.concat new_strategies
  end
end
Strategy.all_bank_strategies.each do |bank_strategy|
  new_strategies = strategy_matrix.dup
  new_strategies.each do |strategy|
    strategy.bank_min = bank_strategy
  end
  strategy_matrix.concat new_strategies
end
@total_games = 0
time = Benchmark.measure do
(strategy_matrix.combination(2).to_a).each do |pair|
  @player1 = Player.new
  @player1.strategies = pair[0]
  @player2 = Player.new
  @player2.strategies = pair[1]
  @player1_games = 0
  @player2_games = 0
  @games_count = 0
  @num_games = 1
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
      while not dice.farkle? and not @current_player.banked? and not @current_player.passing? do
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
        if @current_player.passing?
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
      @current_player.passing = false
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
    @player1.strategies.total_games += 1
    @player2.score = 0
    @player2.strategies.total_games += 2
    if @winning_player == @player1
      @player1_games += 1
      @player1.strategies.wins += 1
    else
      @player2_games += 1
      @player2.strategies.wins += 1
    end
    @games_count += 1
    @total_games += 1
  end
end
end

strategy_matrix.sort_by {|strategy| strategy.wins}.reverse[0..9].each do |strategy|
  puts strategy.to_s + ", bank_min: #{strategy.bank_min}"
  puts "#{strategy.wins.to_f/strategy.total_games.to_f*100}"
end

puts time