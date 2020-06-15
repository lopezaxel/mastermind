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
    puts "Enter any of the next colors with spaces after each color: "
    p @board.colors_code

    until @correct_guess || @player_guesses > @max_guesses
      player_guess = @human.make_guess
      @correct_guess = check_guess(player_guess, @computer.code)
      give_feedback(player_guess, @computer.code)

      @player_guesses += 1
    end

    print "\nType 'yes' to restart the game: "
    restart_answer = gets.chomp
    restart_game if restart_answer == "yes"
  end

  def restart_game
    @computer.restart_computer
    @correct_guess = false
    @player_guess = 0
    start_game
  end

  def check_guess(guess, code)
    return guess == code
  end

  def give_feedback(guess, code)
    copy_code = code.slice(0, code.length)

    guess.each_with_index do |color, index|
      if guess[index] == copy_code[index]
        copy_code[index] = ""
        guess[index] = ""
        puts correct_color_and_position(color, index)
      end
    end

    guess.each_with_index do |color, index|
      copy_code.each_with_index do |let, ind| 
        if let == color && color != ""
          puts correct_color(color, index)
          copy_code[ind] = ""
          break
        end
      end
    end
  end

  def correct_color_and_position(color, position)
    "Color #{color} at position #{position + 1} is correct."
  end
  
  def correct_color(color, position)
    "Color #{color} at position #{position + 1} is correct but at incorrect " + 
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
  attr_reader :colors_code

  def initialize
    @colors_code = ["red", "blue", "yellow", "green", "purple", "orange"]
  end

  def select_random_code(code)
    4.times { code << @colors_code.sample }
    return code
  end
end

class Computer
  attr_reader :code

  def initialize(board)
    @code = []
    @code = board.select_random_code(@code)
    @board = board
  end

  def restart_computer
    @code = []
    @code = @board.select_random_code(@code)
  end
end

class Human
  def initialize
    
  end

  def make_guess
    print "\nEnter your guess: "
    guess = gets.chomp
    guess = guess.split(" ")

    guess
  end
end


human = Human.new
board = Board.new
computer = Computer.new(board)
game = Game.new(human, computer, board) 

game.start_game