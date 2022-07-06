module Messages

  def clear_screen
    system("cls") || system("clear")
  end


end


class Board 

  attr_accessor :board

  def initialize()
    @first_row = { a: ' ', b: ' ', c: ' '}
    @second_row = { a: ' ', b: ' ', c: ' '}
    @third_row = { a: ' ', b: ' ', c: ' '}

    @board = [@first_row, @second_row, @third_row]

  end

  def upadate_row(row, column, value)
    if row[column] == ' '
      row[column] = value
      return true
    end
    false
  end
  def print_board
    puts '  A   B   C '
    i = 1
    @board.each do | v |
      puts "#{i} #{v[:a]} | #{v[:b]} | #{v[:c]} "
      i += 1
    end
  end

end

class Game
  include Messages
  attr_accessor :board

  def initialize
    @board = Board.new
    @player_one = ''
    @player_two = ''
    @score = [0, 0]
    @move = []
  end 

  def begining 
    puts "Insert name of player one"
    @player_one = gets.chomp
    clear_screen
    puts "Insert name of player two"
    @player_two = gets.chomp
    clear_screen
    puts "#{@player_one}: is X and #{@player_two} is: O"
  end
    
  def play
    board.print_board
    puts 'Insert your play (for example: A1)'
    turn = [@player_one, @player_two]
    loop do
      if turn[0] == @player_one
        cross_circle = 'X'
      else
        cross_circle = 'O'
      end

      @move = gets.chomp.downcase.split('')
      clear_screen
      unless board.upadate_row(@board.board[@move[1].to_i-1], @move[0].to_sym, cross_circle)
        puts "It's #{turn[0]} turn"
        board.print_board
        puts 'Choose another spot'
        next
      end
      break if check_for_winner(board)
      puts "It's #{turn[0]} turn"
      board.print_board
      turn.reverse!
    end
  end

  def finish
    p 'We have a Winner'
  end

  def check_for_winner(board)
    winner = false
    board.board.each do |row|
      winner = true if row[:a] == row[:b] && 
                              row[:b] == row[:c] && 
                              row[:c] != ' '
    end
    %i[a b c].each do |column|
      winner = true if  board.board[0][column] == board.board[1][column] &&
                        board.board[1][column] == board.board[2][column] &&
                        board.board[0][column] != ' '
    end

    winner = true if  board.board[0][:a] == board.board[1][:b] &&
                      board.board[1][:b] == board.board[2][:c] &&
                      board.board[0][:a] != ' '

    winner = true if  board.board[0][:c] == board.board[1][:b] &&
                      board.board[1][:b] == board.board[2][:a] &&
                      board.board[0][:c] != ' '
    winner
  end
end

juego = Game.new

juego.begining
juego.play
juego.finish