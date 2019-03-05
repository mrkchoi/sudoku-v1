require 'byebug'
require_relative './board.rb'

class Game
  def initialize
    @game_board = Board.new
  end

  def start_game
    welcome_user
    ask_user_to_start_game
    load_new_game_board

    until @game_board.solved?
      @game_board.play_round
    end

    @game_board.render_board(@game_board.public_board)
    winning_message if @game_board.solved?
  end

  ################################
  # PROMPTS
  ################################

  def welcome_user
    system("clear")
    print "\nWelcome to Sudoku!\n\n"
    print "Sudoku is one of the most popular puzzle games of all time.\nThe goal of Sudoku is to fill a 9×9 grid with numbers so that each row,\ncolumn and 3×3 section contain all of the digits between 1 and 9. \n\n"
  end

  def ask_user_to_start_game
    print "Ready to play? (Y/N): "
    user_input_start_game = gets.chomp
    if valid_start_game_input?(user_input_start_game)
      print "Great, let's get started!\n"
      sleep(1)
    else
      ask_user_to_start_game
    end
  end

  def valid_start_game_input?(input)
    input.upcase == 'Y'
  end

  ################################
  # LOAD GAME BOARD
  ################################

  def load_new_game_board
    @game_board.create_public_board_from_file
  end

  ################################
  # WINNING MESSAGE
  ################################

  def winning_message
    print "\n\n*****************************************************************\n*****************************************************************\nCongratulations!!!\nYou've completed the Sudoku board!\n*****************************************************************\n*****************************************************************\n\n"
  end
end

g = Game.new
g.start_game