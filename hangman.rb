require 'colorize'
require 'yaml'
require 'time'

class Hangman
  def initialize
    @min_length = 5
    @max_length = 12
    @secret_word = generate_secret_word
    @mask = '_ ' * @secret_word.length
    @remaining_guesses = 8
    @letters_used = []
  end

  def generate_secret_word
    words = File.readlines('google-10000-english-no-swears.txt').map(&:chomp).select do |word|
      word.length.between?(@min_length, @max_length)
    end
    words.sample.upcase
  rescue IOError => e
    puts "An error occurred while reading the file: #{e.message}"
  end

  def guess
    loop do
      puts 'ENTER YOUR GUESS:'.colorize(color: :gray, background: :white)
      g = gets.chomp.upcase
      return g if g.match?(/^[A-Z]$/)
    end
  end

  def user_number_choice(down_limit, up_limit)
    loop do
      puts 'ENTER YOUR CHOISE:'.colorize(color: :gray, background: :white)
      choice = gets.chomp.to_i
      return choice if choice.between?(down_limit, up_limit)

      puts 'INVALID CHOICE. '.colorize(color: :red, background: :white)
    end
  end

  def display_before_move
    puts "\n"
    puts "REMAINING GUESSES: #{@remaining_guesses} ".colorize(color: :blue, background: :white)
    puts "USED LETTERS: #{@letters_used.join(', ')} ".colorize(color: :blue, background: :white)
    puts "SECRET: #{@mask} ".colorize(color: :blue, background: :white)
    puts 'DO YOU WANT TO SAVE YOUR GAME? (y/n)'.colorize(color: :gray, background: :white)
    answer = gets.chomp.upcase
    %w[Y YES].include?(answer)
  end

  def display_win
    puts "CONGRATS!! YOU FOUND THE SECRET WORD, WITH #{@remaining_guesses} GUESSES REMAINING!! ".colorize(
      color: :white, background: :green
    )
    puts "SECRET: #{@secret_word} ".colorize(color: :white, background: :green)
  end

  def display_defeat
    puts 'YOU USED ALL THE GUESSES. BETTER LUCK NEXT TIME  '.colorize(color: :red, background: :white)
    puts "SECRET WORD: #{@secret_word}  ".colorize(color: :red, background: :white)
  end

  def run
    puts "LET'S PLAY HANGMAN.".colorize(color: :blue, background: :white)
    puts ' [1] START A NEW GAME '.colorize(color: :blue, background: :white)
    puts ' [2] LOAD AN OLD GAME '.colorize(color: :blue, background: :white)

    case user_number_choice(1, 2)
    when 1 then start_game
    when 2 then load_game
    end
  end

  def start_game
    loop do
      need_for_save = display_before_move
      save_game if need_for_save
      letter = guess
      if @secret_word.include?(letter)
        update_mask(letter)
      else
        @letters_used << letter
        @remaining_guesses -= 1
      end

      break if end?
    end
  end

  def update_mask(letter)
    @secret_word.chars.each_with_index do |char, index|
      @mask[index * 2] = char if char == letter
    end
  end

  def end?
    if @remaining_guesses.zero?
      display_defeat
      true
    elsif @secret_word == @mask.delete(' ')
      display_win
      true
    else
      false
    end
  end

  def save_game
    # make folder for the need_for_saved games
    Dir.mkdir('save') unless Dir.exist?('save')

    # the file name
    filename = "save/hangman_#{Time.now.strftime('%Y%m%d_%H%M%S')}.yaml"

    # need_for_save the game state to a YAML file
    File.open(filename, 'w') do |file|
      file.write(YAML.dump({
                             secret_word: @secret_word,
                             mask: @mask,
                             remaining_guesses: @remaining_guesses,
                             letters_used: @letters_used
                           }))
    end

    puts 'GAME SAVED! '.colorize(color: :green, background: :white)
  end

  def load_game
    # Display the files
    save_files = display_files('save')
    return start_game if save_files.empty?

    # Choose a file
    choice = user_number_choice(1, save_files.length)

    # Get data from that file
    filename = "save/#{save_files[choice - 1]}"
    game_state = YAML.load_file(filename)
    @secret_word = game_state[:secret_word]
    @mask = game_state[:mask]
    @remaining_guesses = game_state[:remaining_guesses]
    @letters_used = game_state[:letters_used]

    puts 'GAME LOADED SUCCESSFULLY.'.colorize(color: :green, background: :white)
    start_game
  end

  def display_files(directory)
    # Check for the saves folder
    unless Dir.exist?(directory)
      puts 'save FOLDER NOT FOUND. STARTING A NEW GAME.'.colorize(color: :red, background: :white)
      return []
    end

    # Check if there are any files in the folder
    save_files = Dir.entries(directory).select { |f| f.end_with?('.yaml') }
    if save_files.empty?
      puts 'NO SAVED GAMES FOUND. STARTING A NEW GAME.'.colorize(color: :red, background: :white)
      return []
    end

    puts 'CHOOSE A FILE TO LOAD:'.colorize(color: :blue, background: :white)
    save_files.each_with_index do |file, index|
      puts "[#{index + 1}] #{file}".colorize(color: :blue, background: :white)
    end
    save_files
  end
end

Hangman.new.run
