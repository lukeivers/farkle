class Dice < Array
  def initialize
    self.concat [0, 0, 0, 0, 0, 0]
  end
  def roll
    if size == 0
      initialize
    end
    (0..(size - 1)).each do |index|
      self[index] = 1 + rand(6)
    end
    if $debug
      puts self.to_s
    end
  end
  def choose(indexes)
    new_dice = []
    each_with_index do |die, index|
      if not indexes.include? index
        new_dice << die
      end
    end
    self.replace(new_dice)
    if $debug
      puts self.to_s
    end
  end
  def farkle?
    if has_points?
      return false
    end
    return true
  end
  def has_points?
    if ones? > 0 or fives? > 0 or has_set? or has_straight? or has_pairs?
      return true
    end
    return false
  end
  def has_set?
    if ones? >= 3 or twos? >= 3 or threes? >= 3 or fours? >= 3 or fives? >= 3 or sixes? >= 3
      return true
    end
    return false
  end
  def has_straight?
    if size == 6
      if sort == [1, 2, 3, 4, 5, 6]
        return true
      end
    end
    return false
  end
  def has_pairs?
    if size == 6
      if counts.count(2) == 3
        return true
      end
      return false
    end
  end
  def indexes(number)
    indexes = []
    each_with_index do |die, index|
      if die == number
        indexes << index
      end
    end
    indexes
  end
  def ones?
    count(1)
  end
  def twos?
    count(2)
  end
  def threes?
    count(3)
  end
  def fours?
    count(4)
  end
  def fives?
    count(5)
  end
  def sixes?
    count(6)
  end
  def counts
    [ones?, twos?, threes?, fours?, fives?, sixes?]
  end
end