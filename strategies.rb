class Strategy < Array
  attr_accessor :bank_min
  attr_accessor :wins
  attr_accessor :total_games

  def self.all_single
    [
        :choose_straight,
        :choose_pairs,
        :choose_set,
    ]
  end

  def self.all_multiple
    [
        [ :choose_all_ones, :choose_single_one ],
        [ :choose_all_fives, :choose_single_five ],
    ]
  end

  def self.all_bank_strategies
    [ 500, 750 ]
  end

  def initialize(arg = nil)
    @wins = 0
    @total_games = 0
    @bank_min = 300
    if arg != nil
      super(arg)
    end
  end

  def stop_gap(dice = Dice.new)
    if dice.ones? > 0
      return self.method(:choose_single_one)
    elsif dice.fives? > 0
      return self.method(:choose_single_five)
    elsif dice.has_set?
      return self.method(:choose_set)
    elsif dice.has_pairs?
      return self.method(:choose_pairs)
    else
      return self.method(:choose_straight)
    end
  end

  def available?(dice = Dice.new)
    available_strategies = []
    if dice.has_straight? and self.include? :choose_straight
      available_strategies << self.method(:choose_straight)
    end
    if dice.has_pairs? and self.include? :choose_pairs
      available_strategies << self.method(:choose_pairs)
    end
    if dice.has_set? and self.include? :choose_set
      available_strategies << self.method(:choose_set)
    end
    if dice.ones? > 0
      if self.include? :choose_all_ones
        available_strategies << self.method(:choose_all_ones)
      elsif self.include? :choose_single_one
        available_strategies << self.method(:choose_single_one)
      end
    end
    if dice.fives? > 0
      if self.include? :choose_all_fives
        available_strategies << self.method(:choose_all_fives)
      elsif self.include? :choose_single_five
        available_strategies << self.method(:choose_single_five)
      end
    end
    available_strategies
  end
  def choose_straight(dice = Dice.new)
    if $debug
      puts 'chose a straight'
    end
    dice.choose([0, 1, 2, 3, 4, 5, 6])
    return 1500
  end
  def choose_pairs(dice = Dice.new)
    if $debug
      puts 'chose 3 pair'
    end
    dice.choose([0, 1, 2, 3, 4, 5, 6])
    return 750
  end
  def choose_set(dice = Dice.new)
    max_count = 0
    best_index = -1
    dice.counts.each_with_index do |count, index|
      if count > max_count
        max_count = count
        best_index = index
      end
    end
    best_index += 1
    if $debug
      puts "chose #{max_count} #{best_index}'s"
    end
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
    if $debug
      puts "base_score #{base_score}, multiple #{multiple}, calculated: #{base_score * multiple}"
    end
    return base_score * multiple
  end
  def choose_all_ones(dice = Dice.new)
    ones = dice.ones?
    if $debug
      puts "chose #{ones} 1's"
    end
    dice.choose(dice.indexes(1))
    return ones * 100
  end
  def choose_single_one(dice = Dice.new)
    if $debug
      puts "chose 1 1's"
    end
    dice.choose([dice.index(1)])
    return 100
  end
  def choose_all_fives(dice = Dice.new)
    fives = dice.fives?
    if $debug
      puts "chose #{fives} 5's"
    end
    dice.choose(dice.indexes(5))
    return fives * 100
  end
  def choose_single_five(dice = Dice.new)
    if $debug
      puts "chose 1 5"
    end
    dice.choose([dice.index(5)])
    return 50
  end
  def bank_at_300
    @bank_min = 300
  end
  def bank_at_500
    @bank_min = 500
  end
  def bank_at_750
    @bank_min = 750
  end
  def bank(dice = Dice.new, current_score = 0)
    temp_score = -1
    if current_score >= @bank_min
      if $debug
        puts "cleaning up"
      end
      temp_score = 0
      ones = dice.ones?
      if ones > 0
        if $debug
          puts "chose #{ones} 1's"
        end
        dice.choose(dice.indexes(1))
        temp_score += ones * 100
      end
      fives = dice.fives?
      if fives > 0
        if $debug
          puts "chose #{fives} 5's"
        end
        dice.choose(dice.indexes(5))
        temp_score += fives * 50
      end
    end
    return temp_score
  end

  def percentage
    self.wins.to_f/self.total_games.to_f
  end
end