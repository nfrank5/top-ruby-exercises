# frozen_string_literal: true

class Board 
  attr_reader :board

  def initialize
    @first_row = { a: ' ', b: ' ', c: ' ' }
    @second_row = { a: ' ', b: ' ', c: ' ' }
    @third_row = { a: ' ', b: ' ', c: ' ' }
    @board = [@first_row, @second_row, @third_row]

  end

  def update_row(row, column, value)
    if board[row][column] == ' '
      board[row][column] = value
      return true
    end
    false
  end

  def check_for_winner(player)
    winner = false
    board.each do |row|
      winner = true if  row[:a] == row[:b] &&
                        row[:b] == row[:c] &&
                        row[:c] != ' '
    end
    %i[a b c].each do |column|
      winner = true if  board[0][column] == board[1][column] &&
                        board[1][column] == board[2][column] &&
                        board[0][column] != ' '
    end
    winner = true if  board[0][:a] == board[1][:b] &&
                      board[1][:b] == board[2][:c] &&
                      board[0][:a] != ' '

    winner = true if  board[0][:c] == board[1][:b] &&
                      board[1][:b] == board[2][:a] &&
                      board[0][:c] != ' '
    puts "#{player} is the winner!!!" if winner
    winner
  end

  def print_board
    puts '  A   B   C '
    i = 1
    @board.each do |v|
      puts "#{i} #{v[:a]} | #{v[:b]} | #{v[:c]} "
      i += 1
    end
  end
end

class Game
  attr_accessor :current_board

  def initialize
    @current_board = Board.new
    @player_one = ''
    @player_two = ''
    @move = []
  end

  def clear_screen
    system('cls') || system('clear')
  end

  def get_players
    puts 'Insert name of player one'
    @player_one = gets.chomp
    puts 'Insert name of player two'
    @player_two = gets.chomp
    clear_screen
  end

  def play
    current_board.print_board
    puts 'Mark a space(for example: A1)'
    turn = [@player_one, @player_two]
    we_have_a_winner = false
    9.times do
      cross_circle = turn[0] == @player_one ? 'X' : 'O'
      puts "#{@player_one}: is X and #{@player_two} is: O"
      loop do
        puts "It's #{turn[0]} turn"
        @move = gets.chomp.downcase.split('')
        clear_screen
        unless current_board.update_row(@move[1].to_i - 1, @move[0].to_sym, cross_circle)
          current_board.print_board
          puts 'Mark a free space'
          next
        end
        break
      end
      we_have_a_winner = current_board.check_for_winner(turn[0])
      break if we_have_a_winner
      current_board.print_board
      turn.reverse!
    end
    unless we_have_a_winner
      clear_screen
      puts "It's a draw"
    end
    current_board.print_board
  end


end

juego = Game.new
juego.get_players
juego.play
