# mastermind.rb

require "pry"

class Game
  def initialize(human, computer, board)
    @correct_guess = false
    @max_guesses = 12
    @player_guesses = 0

    @human = human
    @computer = computer
    @board = board
  end

  def start_game
    until @correct_guess || @player_guesses > @max_guesses
      player_guess = @human.make_guess
      @correct_guess = check_guess(player_guess, @computer.code)
      give_feedback(player_guess, @computer.code)

      @player_guesses += 1
    end

    print "\nType 'yes' to restart the game: "
    restart_answer = gets.chomp
    # restart_game if restart_answer == "yes"
  end

  def restart_game
    @computer.restart_computer
    initialize
  end

  def check_guess(guess, code)
    return guess == code
  end

  def give_feedback(guess, code)
    copy_code = code.slice(0, code.length)

    guess.each_with_index do |letter, index|
      if guess[index] == copy_code[index]
        copy_code[index] = ""
        puts correct_letter_and_position(letter, index)
      elsif copy_code.include?(letter)
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
  attr_reader :code

  def initialize(board)
    @code = []
    @code = board.select_random_code(@code)
  end

  def restart_computer
    initialize
  end
end

class Human
  def initialize
    
  end

  def make_guess
    print "\nEnter your guess: "
    guess = gets.chomp
    guess = guess.split("")

    guess
  end
end


human = Human.new
board = Board.new
computer = Computer.new(board)
game = Game.new(human, computer, board) 

game.start_game