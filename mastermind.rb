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
    @combinations = [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
  end

  def welcome
    choose_maker_breaker = ''
    puts 'Welcome to Mastermind Game!'
    puts 'The game where you need to discover a secret pattern of four colours'
    puts 'Do you want to be the Codemaker or the Codebreaker?'
    until choose_maker_breaker.downcase.match(/^[1-2]$/)
      puts 'Write 1 to be the Codemaker or 2 to be the Codebreaker'
      choose_maker_breaker = gets.chomp
    end
    choose_maker_breaker.to_i
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

  def player_create_hidden_code
    code_string = ''
    puts 'Choose four of the following colors to creat the hidden pattern.'
    CODE_PEGS.each_index { |index| puts "#{index.to_i + 1}. #{CODE_PEGS[index].capitalize}" }
    until code_string.match(/^[1-6]{4}$/)
      puts 'Write only four digits without spaces'
      code_string = gets.chomp
    end
    code_string.split('').map(&:to_i)
  end

  def feedback(guess, hidden_code)
    black_key_pegs = []
    white_key_pegs = []
    multiple_white_key_pegs = [] # Used to show the correct amount of white pegs when guess contains repeated colors
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
    feedback.count(0) == 4
  end
                           
  def computer_guess_pattern(feedback, last_guess, hidden_code_pattern) 
    new_guess = []
    @combinations = @combinations.select { |element| feedback(element, last_guess) == feedback(last_guess, hidden_code_pattern) }
    @combinations[0]
  end

  def play_game

    type_of_game = welcome
    p type_of_game
    if  type_of_game == 2
      play_game_codebraker
    else
      play_game_codemaker
    end

  end

  def play_game_codebraker
    game_board = Board.new
    @hidden_code_pattern = generate_hidden_code_pattern
    12.downto(1) do |i|
      clear_screen
      # p @hidden_code_pattern
      game_board.print_board
      puts "You have #{i} #{i == 1 ? 'guess' : 'guesses'} left"
      @guess_pattern = player_guess_pattern 
      @feedback = feedback(@guess_pattern, @hidden_code_pattern)
      game_board.add_pattern(@guess_pattern, @feedback)
      if winner?(@feedback)
        puts 'You Won, press Enter.'
        gets
        break
      end
    end
    clear_screen
    puts 'Final board'
    game_board.print_board
    puts 'Game Over'
  end

  def play_game_codemaker
    game_board = Board.new

    @hidden_code_pattern = player_create_hidden_code
    last_guess = []
    12.downto(1) do |i|
      clear_screen
      # p @hidden_code_pattern
      game_board.print_board
      puts "Computer has #{i} #{i == 1 ? 'guess' : 'guesses'} left"
      if last_guess ==[]
        @guess_pattern = [1, 1, 2, 2]
      else
        @guess_pattern = computer_guess_pattern(@feedback, last_guess, @hidden_code_pattern)
      end
      @feedback = feedback(@guess_pattern, @hidden_code_pattern)
      game_board.add_pattern(@guess_pattern, @feedback)
      last_guess = @guess_pattern
      if winner?(@feedback)
        puts 'Computer Won, press Enter.'
        gets
        break
      end
    end
    clear_screen
    puts 'Final board'
    game_board.print_board
    
    puts 'Game Over'
  end



end

juego = Game.new
juego.play_game
