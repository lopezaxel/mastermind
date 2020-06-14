class Game
  def initialize
    @correct_guess = false
    @max_number_guesses = 12
    @player_guesses = 0
  end

  def check_guess(guess, code)
    return guess == code
  end

  def give_feedback(guess, code)
    guess.each_with_index do |letter, index|
      if guess[index] == code[index]
        puts correct_letter_and_position(letter, index)
      elsif code.include?(letter)
        puts correct_letter(letter, index)
      end
    end
  end

  def correct_letter_and_position(letter, position)
    "Letter #{letter} at position #{position + 1} is correct."
  end
  
  def correct_letter(letter, position)
    "Letter #{letter} at position #{position + 1} is correct but at incorrect " + 
      "position."
  end

  def correct_guess(guess)
    "Guess #{guess} is equal to the code!"
  end

  def set_guess_to_true
    @correct_guess = true
  end
end

class Board
  def initialize
    @possible_letters_code = ["A", "B", "C", "D", "E", "F"]
  end

  def select_random_code(code)
    4.times { code << @possible_letters_code.sample }
    return code
  end
end

class Computer
  def initialize(board)
    @code = []
    @code = board.select_random_code(@code)
  end
end

class Human
  def initialize
    
  end

  def make_guess
    print "Enter your guess: "
    gets.chomp
  end
end


game = Game.new
human = Human.new
board = Board.new
computer = Computer.new(board)

game.check_guess(["A", "B", "C", "D"], board.select_random_code([]))