require 'colorize'
require 'colorized_string'
require './tile.rb'
require 'byebug'

class Board
  # attr_reader :board_file
  attr_accessor :public_board 

  def initialize
    @public_board_file = File.new('./puzzles/sudoku1.txt').readlines
    @public_board = Array.new(9) {Array.new(9)}
    # @private_board
  end

  ##############################
  # CREATE BOARD
  ##############################
  def create_public_board_from_file
    create_board_array_from_file(@public_board, @public_board_file)
    convert_board_array_to_tiles(@public_board)
  end

  def create_board_array_from_file(board, file)
    file.each_with_index do |line, i|
      line.chomp.each_char.with_index do |char, j|
        board[i][j] = char.to_i
      end
    end
    # print @public_board
  end

  def convert_board_array_to_tiles(board)
    # map through elements of public board & replace each el w/ tile instance
    board.each_with_index do |line, i|
      line.each_with_index do |char, j|
        if board[i][j] == 0
          board[i][j] = Tile.new(board[i][j], true)
        else
          board[i][j] = Tile.new(board[i][j], false)
        end
      end
    end
  end

  def render_board(board)
    print "\n   0  1  2   3  4  5   6  7  8 \n"
    board.each_with_index do |line, i|
        print "#{i} "
        line.each_with_index do |char, j|
          if j == 2 || j == 5
            print board[i][j].colorize + ' '
          else
            print board[i][j].colorize
          end
        
        end
        print "\n"
        print "\n" if i == 2 || i == 5
      end
      # print "\nSolve all of the white entries..\n"
  end


  ##############################
  # PLAY ROUND
  ##############################

  def play_round
    # render board
    render_board(@public_board)
    # prompt for user input
    update_board(get_user_input) # => [[x,y], value]
    # validate/format user input
    # update/rerender board
  end

  ##############################
  # GET USER INPUT
  ##############################

  def get_user_input
    print "\nEnter you move (e.g. 004 => [0,0], 4)\n"
    user_input = gets.chomp
    if valid_user_input?(user_input)
      user_input
    else
      print "Please enter a valid move.."
      get_user_input
    end
  end

  def format_user_input(user_input)
    int_input = user_input.chars.map(&:to_i)
    return [[int_input[0],int_input[1]], int_input[2]]
  end

  ##############################
  # VALIDATE MOVE
  ##############################

  def valid_user_input?(user_input)
    formatted_input = format_user_input(user_input)
    if valid_input_length_and_chars?(formatted_input) && playable_move?(formatted_input)
      return true
    end
    false
  end

  # => [[0, 8], 4]
  def valid_input_length_and_chars?(formatted_input) # => [[x,y], value]
    input_length_two = (formatted_input.length == 2)
    input_is_array = formatted_input.is_a?(Array)
    pos_as_array_and_length_two = formatted_input[0].is_a?(Array) && formatted_input[0].length == 2
    pos_values_in_range = formatted_input[0][0] >= 0 && formatted_input[0][0] <= 8 && formatted_input[0][1] >= 0 && formatted_input[0][1] <= 8
    value_is_int = formatted_input[1].is_a?(Integer)
    value_in_range = formatted_input[1] >= 0 && formatted_input[1] <= 8

    input_length_two && input_is_array && pos_as_array_and_length_two && pos_values_in_range && value_is_int && value_in_range
    
  end

  def playable_move?(player_move) # => [[0,1], 4]
    position = player_move[0]
    @public_board[position[0]][position[1]].playable
  end

  ##############################
  # GAME LOGIC HELPER FUNCTIONS
  ##############################

  ########################################## 2
  # DEFINE HELPER FUNCTIONS TO CHECK FOR SOLVED? [ROW, COLUMN, 3X3 CHECKER]
  def solved?
    all_rows_solved?(@public_board) && 
    all_cols_solved?(@public_board) && 
    all_three_by_three_grids_solved?(@public_board)
  end

# SOLVED BOARD CHECK
# [[4, 8, 3, 9, 2, 1, 6, 5, 7], [9, 6, 7, 3, 4, 5, 8, 2, 1], [2, 5, 1, 8, 7, 6, 4, 9, 3], [5, 4, 8, 1, 3, 2, 9, 7, 6], [7, 2, 9, 5, 6, 4, 1, 3, 8], [1, 3, 6, 7, 9, 8, 2, 4, 5], [3, 7, 2, 6, 8, 9, 5, 1, 4], [8, 1, 4, 2, 5, 3, 7, 6, 9], [6, 9, 5, 4, 1, 7, 3, 8, 2]]

# SAMPLE BOARD FORMATTING
# [[1,2,3,4,5,6,7,8,9],
#  [1,2,3,4,5,6,7,8,9],
#  [1,2,3,4,5,6,7,8,9],
#  [1,2,3,4,5,6,7,8,9],
#  [1,2,3,4,5,6,7,8,9],
#  [1,2,3,4,5,6,7,8,9],
#  [1,2,3,4,5,6,7,8,9],
#  [1,2,3,4,5,6,7,8,9],
#  [1,2,3,4,5,6,7,8,9]]

  def all_rows_solved?(board)
    match = [1,2,3,4,5,6,7,8,9]

    board.all? do |row|
      current_row = row.map {|tile| tile.value}
      current_row.sort == match
    end
  end
  
  def all_cols_solved?(board)
    match = [1,2,3,4,5,6,7,8,9]

    board.each_with_index do |row, row_i|
      converted_col = []
      row.each_with_index do |col, col_i|
        converted_col << board[col_i][row_i].value
      end
      return false if converted_col.sort != match
    end
    true
  end


  def all_three_by_three_grids_solved?(board)
    grid = Array.new(9) {[]}

    board.each_with_index do |row, row_i|
      row.each_with_index do |col, col_i|
        if (row_i >= 0 && row_i <= 2) && (col_i >= 0 && col_i <= 2)
          grid[0] << board[row_i][col_i].value
        elsif (row_i >= 0 && row_i <= 2) && (col_i >= 3 && col_i <= 5)
          grid[1] << board[row_i][col_i].value
        elsif (row_i >= 0 && row_i <= 2) && (col_i >= 6 && col_i <= 8)
          grid[2] << board[row_i][col_i].value
        elsif (row_i >= 3 && row_i <= 5) && (col_i >= 0 && col_i <= 2)
          grid[3] << board[row_i][col_i].value
        elsif (row_i >= 3 && row_i <= 5) && (col_i >= 3 && col_i <= 5)
          grid[4] << board[row_i][col_i].value
        elsif (row_i >= 3 && row_i <= 5) && (col_i >= 6 && col_i <= 8)
          grid[5] << board[row_i][col_i].value
        elsif (row_i >= 6 && row_i <= 8) && (col_i >= 0 && col_i <= 2)
          grid[6] << board[row_i][col_i].value
        elsif (row_i >= 6 && row_i <= 8) && (col_i >= 3 && col_i <= 5)
          grid[7]<< board[row_i][col_i].value
        elsif (row_i >= 6 && row_i <= 8) && (col_i >= 6 && col_i <= 8)
          grid[8] << board[row_i][col_i].value
        end
      end
    end

    match = [1,2,3,4,5,6,7,8,9]

    grid.all? do |row|
      row.sort == match
    end
  end

  

  ##############################
  # UPDATE BOARD
  ##############################

  def update_board(user_input)
    formatted_input = format_user_input(user_input)
    player_input_value = formatted_input[1]

    public_board_position = convert_input_to_public_board_position(formatted_input)

    public_board_position.value = player_input_value    
  end

  # => [[0, 8], 4]
  def convert_input_to_public_board_position(input)
    position = input[0]
    public_board_position = @public_board[position[0]][position[1]]
    public_board_position
  end

end





# c = Board.new
# c.create_public_board_from_file
# c.play_round

# # print c.public_board