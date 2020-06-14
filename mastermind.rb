class Game
  def initialize
    @correct_guess = false
    @max_number_guesses = 12
    @player_guesses = 0
  end
end

class Board
  def initialize
    @possible_letters_code = ["A", "B", "C", "D", "E", "F"]
  end

  def select_random_code
    @code = []
    6.times { @possible_letters_code.sample}
  end
end

class Human
  def initialize
    
  end
end

class Computer
  def initialize
    
  end
end