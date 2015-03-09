require './player'
class SingleOnesPlayer < Player
  def choose(dice = Dice.new)
    if dice.has_straight?
      #puts 'chose a straight'
      dice.choose([0, 1, 2, 3, 4, 5, 6])
      @temp_score += 1500
    elsif dice.has_pairs?
      #puts 'chose 3 pair'
      dice.choose([0, 1, 2, 3, 4, 5, 6])
      @temp_score += 750
    elsif dice.has_set?
      max_count = 0
      best_index = -1
      dice.counts.each_with_index do |count, index|
        if count > max_count
          max_count = count
          best_index = index
        end
      end
      best_index += 1
      #puts "chose #{max_count} #{best_index}'s"
      dice.choose(dice.indexes(best_index))
      multiple = max_count - 3 + 1
      base_score = 0
      if best_index == 1
        base_score = 1000
      elsif best_index == 2
        base_score = 200
      elsif best_index == 3
        base_score = 300
      elsif best_index == 4
        base_score = 400
      elsif best_index == 5
        base_score = 500
      elsif best_index == 6
        base_score = 600
      end
      #puts "base_score #{base_score}, multiple #{multiple}, calculated: #{base_score * multiple}"
      @temp_score += base_score * multiple
    elsif dice.ones? > 0
    elsif dice.fives? > 0
      #puts "chose 1 5"
      dice.choose([dice.index(5)])
      @temp_score += 50
    end
    if @temp_score >= 300
      #puts "cleaning up"
      ones = dice.ones?
      if ones > 0
        #puts "chose #{ones} 1's"
        dice.choose(dice.indexes(1))
        @temp_score += ones * 100
      end
      fives = dice.fives?
      if fives > 0
        #puts "chose #{fives} 5's"
        dice.choose(dice.indexes(5))
        @temp_score += fives * 50
      end
      @banked = true
    end
  end
end