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
         'of the code: '
    answer = gets.chomp

    if answer == 'guess'
      until @correct_guess || @player_guesses > @max_guesses
        player_guess = @human.make_guess
        @correct_guess = check_guess(player_guess, @computer.code)
        give_feedback(player_guess, @computer.code)

        @player_guesses += 1
      end

    elsif answer == 'code'
      player_code = @human.make_guess
      computer_code = @computer.code

      until @correct_guess || @player_guesses > @max_guesses
        final_guess = ['', '', '', '']
        player_copy = player_code.slice(0, player_code.length)

        computer_code.each_with_index do |color, index|
          if color == player_copy[index]
            player_copy[index] = ''
          else
            final_guess[index] = color
            computer_code[index] = ''
          end
        end

        final_guess.each_with_index do |color, index|
          player_copy.each_with_index do |col, ind|
            next if !(col == color && color != '')

            empty_place = select_empty_string(computer_code)
            computer_code[empty_place] = color
            final_guess[index] = ''
            player_copy[ind] = ''
          end
        end

        computer_code.each_with_index do |color, index|
          computer_code[index] = @board.get_random_color if color == ''
        end

        p computer_code

        @correct_guess = check_guess(computer_code, player_code)
        @player_guesses += 1
      end
    end

    print "\nType 'yes' to restart the game: "
    restart_answer = gets.chomp
    restart_game if restart_answer == 'yes'
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
        next unless color_code == color && color != ''

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
    print "\nEnter your guess: "
    guess = gets.chomp
    guess = guess.split(' ')

    guess
  end

  def enter_secret_code
    print "\nEnter the secret code: "
    code = gets.chomp
    code = code.split(' ')

    code
  end
end

human = Human.new
board = Board.new
computer = Computer.new(board)
game = Game.new(human, computer, board)

game.start_game
