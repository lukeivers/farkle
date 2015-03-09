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
    @strategies.bank_min = rand(450)+300
    puts @strategies.bank_min.to_s
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
    banked_value = @strategies.bank(dice, @temp_score)
    if banked_value >= 0
      @temp_score += banked_value
      @banked = true
    end
  end
  def banked?
    banked
  end
end