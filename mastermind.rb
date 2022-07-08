CODE_PEGS = %w[red yellow blue green orange purple].freeze
KEY_PEGS = %w[black white].freeze

class Player
  def initialize(name)
    @name = name
  end
end

class Board
  attr_reader :guess_pattern_history

  def initialize
    @guess_pattern_history = []
    @feedback_history = []
  end

  def convert_pattern_to_colors(numbers)
    numbers.inject([]) { |colors, number| colors.push(CODE_PEGS[number-1]) }
  end

  def convert_feedback_to_colors(numbers)
    numbers.inject([]) { |colors, number| colors.push(KEY_PEGS[number]) }
  end

  def add_pattern(pattern, feedback)
    @guess_pattern_history.push(convert_pattern_to_colors(pattern))
    @feedback_history.push(convert_feedback_to_colors(feedback))
  end

  def print_board
    @guess_pattern_history.each_index do |i|
      puts "Guess: #{guess_pattern_history[i]} Feedback:#{@feedback_history[i]} "
    end
  end
end

class Game

  def initialize

    @allow_duplicates = false
    @hidden_code_pattern = []
    @feedback = []
    @guess_pattern = ''
  end

  def welcome
    puts 'Welcome to Mastermind Game!'
    puts 'The game where you need to discover a secret pattern of four colours'
  end

  def player_guess_pattern
    code_string = ''
    puts 'Try to guess the pattern, choose four of the following colors.'
    CODE_PEGS.each_index { |index| puts "#{index.to_i + 1}. #{CODE_PEGS[index].capitalize}" }
    until code_string.match(/^[1-6]{4}$/)
      puts 'Write only four digits without spaces'
      code_string = gets.chomp
    end
    code_string.split('').map(&:to_i)
  end

  def generate_hidden_code_pattern
    code = []
    4.times { code.push(rand(1..6)) }
    code
  end

  def feedback(guess, hidden_code)
    black_key_pegs = []
    white_key_pegs = []
    multiple_white_key_pegs = []
    final_key_pegs = []
    guess.each_index do |i|
      if guess[i] == hidden_code[i]
        black_key_pegs.push(guess[i])
      elsif hidden_code.include?(guess[i]) && guess.count(guess[i]) < 2
        final_key_pegs.push(1)
      elsif guess.count(guess[i]) >= 2 && hidden_code.include?(guess[i])
        multiple_white_key_pegs.push(guess[i])
      end
    end
    multiple_white_key_pegs.uniq.each do |element|
      if hidden_code.count(element) - black_key_pegs.count(element) <= multiple_white_key_pegs.count
        (hidden_code.count(element) - black_key_pegs.count(element)).times { final_key_pegs.push(1) }
      else
        multiple_white_key_pegs.count.times { final_key_pegs.push(1)}
      end
    end
    black_key_pegs.length.times { final_key_pegs.push(0)}
    black_key_pegs + white_key_pegs + multiple_white_key_pegs
    final_key_pegs.sort
  end

  def clear_screen
    system('cls') || system('clear')
  end

  def winner?(feedback)
    feedback.count('black') == 4
  end

  def play_game
    game_board = Board.new
    fb = []
    welcome
    @hidden_code_pattern = generate_hidden_code_pattern
    12.downto(1) do |i|
      clear_screen
      # p @hidden_code_pattern
      game_board.print_board
      puts "You have #{i} " + (i==1?"guess":"guesses") + " left"
      @guess_pattern = player_guess_pattern 
      fb = feedback(@guess_pattern, @hidden_code_pattern)
      game_board.add_pattern(@guess_pattern, fb)
      if winner?(fb)
        puts "You Won"
        break
      end
    end
    clear_screen
    puts 'Game Over'
    game_board.print_board
  end
end

juego = Game.new
juego.play_game
