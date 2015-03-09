require './dice'
require './strategies'

class Player
  attr_accessor :score
  attr_accessor :temp_score
  attr_accessor :banked
  attr_accessor :strategies
  def initialize
    @score = 0
    @temp_score = 0
    @banked = false
    @strategies = Strategy.new
  end
  def choose(dice = Dice.new)
    done = false
    while not done
      chosen_strategy = @strategies.available?(dice).sample
      score = chosen_strategy.call(dice)
      @temp_score += score
      if @strategies.available?(dice).size == 0
        done = true
      elsif rand(2) == 0
        done = true
      end
    end
    if @temp_score >= rand(450)+300
      if $debug
        puts "cleaning up"
      end
      ones = dice.ones?
      if ones > 0
        if $debug
          puts "chose #{ones} 1's"
        end
        dice.choose(dice.indexes(1))
        @temp_score += ones * 100
      end
      fives = dice.fives?
      if fives > 0
        if $debug
          puts "chose #{fives} 5's"
        end
        dice.choose(dice.indexes(5))
        @temp_score += fives * 50
      end
      @banked = true
    end
  end
  def banked?
    banked
  end
end