# frozen_string_literal: true

# mastermind.rb

require 'pry'

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
    puts "\nType 'guess' to be the guesser\nType 'code' to be creator " \
         "of the code: "

    answer = gets.chomp
    puts "\nPossible colors: red blue yellow orange purple green."

    if answer == 'guess'
      guess_option
    elsif answer == 'code'
      code_option
    end

    check_restart
  end

  def check_restart
    print "\nType 'yes' to restart the game: "
    restart_answer = gets.chomp
    restart_game if restart_answer == 'yes'
  end

  def guess_option
    until @correct_guess || @player_guesses > @max_guesses
      player_guess = @human.make_guess
      @correct_guess = check_guess(player_guess, @computer.code)
      give_feedback(player_guess, @computer.code)

      @player_guesses += 1
    end
  end

  def code_option
    player_code = @human.enter_secret_code

    until @correct_guess || @player_guesses > @max_guesses
      temporal_guess = ['', '', '', '']
      player_copy = player_code.slice(0, player_code.length)

      # If color and position matches keep it, if color is present but in
      # wrong position change position and keep it, and color doesn't match
      # replace with random color.
      keep_right_colors(@computer.code, player_copy, temporal_guess)
      move_present_colors(@computer.code, player_copy, temporal_guess)
      random_colors_if_incorrect(@computer.code)

      p @computer.code

      @correct_guess = check_guess(@computer.code, player_code)
      @player_guesses += 1
    end
  end

  def random_colors_if_incorrect(guess)
    guess.each_with_index do |color, index|
      guess[index] = @board.get_random_color if color == ''
    end
  end

  def move_present_colors(guess, code, temporal_guess)
    temporal_guess.each_with_index do |color, index|
      code.each_with_index do |col, ind|
        next if !(col == color && color != '')

        empty_place = select_empty_string(guess)
        guess[empty_place] = color
        temporal_guess[index] = ''
        code[ind] = ''
      end
    end
  end

  def keep_right_colors(guess, code, temporal_guess)
    guess.each_with_index do |color, index|
      if color == code[index]
        code[index] = ''
      else
        temporal_guess[index] = color
        guess[index] = ''
      end
    end
  end

  def select_empty_string(guess)
    num_list = (0..3).to_a.shuffle
    num_list.each do |num|
      return num if guess[num] == ''
    end
  end

  def restart_game
    @computer.restart_computer
    @correct_guess = false
    @player_guesses = 0
    start_game
  end

  def check_guess(guess, code)
    guess == code
  end

  def give_feedback(guess, code)
    copy_code = code.slice(0, code.length)

    check_color_position(guess, copy_code)
    check_color(guess, copy_code)
  end

  def check_color_position(guess, code)
    # Check if guess colors are correct in color and position to code ones.
    guess.each_with_index do |color, position|
      next unless guess[position] == code[position]

      puts correct_color_and_position(color, position)

      code[position] = ''
      guess[position] = ''
    end
  end

  def check_color(guess, code)
    # Check if guess colors are present in code but in incorrect position.
    guess.each_with_index do |color, position|
      code.each_with_index do |color_code, position_code|
        next if !(color_code == color && color != '')

        puts correct_color(color, position)

        code[position_code] = ''
        break
      end
    end
  end

  def correct_color_and_position(color, position)
    "Color #{color} at position #{position + 1} is correct."
  end

  def correct_color(color, position)
    "Color #{color} at position #{position + 1} is correct but at incorrect " \
      'position.'
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
    @colors_code = %w[red blue yellow green purple orange]
  end

  def select_random_code(code, num = 4)
    num.times { code << @colors_code.sample }
    code
  end

  def get_random_color
    @colors_code.sample
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
  def initialize; end

  def make_guess
    print "\nEnter your guess, ex 'orange blue orange red': "
    guess = gets.chomp.split(' ')

    guess
  end

  def enter_secret_code
    print "\nEnter the secret code, ex 'orange blue orange red': "
    code = gets.chomp.split(' ')

    code
  end
end

human = Human.new
board = Board.new
computer = Computer.new(board)
game = Game.new(human, computer, board)

game.start_game
