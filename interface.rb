# frozen_string_literal: true

if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__
  [$stdin, $stdout].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require './game_files/game_master'

class Interface
  attr_reader :game, :name
  def initialize
    print 'Введите ваше имя: '
    @name = gets.chomp
    @game = GameMaster.new(name)
    puts "Добро пожаловать, #{name}"
    puts "Ваш баланс: #{game.player.bank}"
    players_turn
  end

  private

  def players_turn
    puts "\n\nВаши карты:"
    i = 1
    game.player.cards.each do |card|
      puts "\tКарта №#{i}: #{card.value}#{card.suit}"
      i += 1
    end
    puts "\n\nКоличество очков: #{game.player.score}"
    puts "Количество карт у дилера:#{game.dealer.cards.count}\n\n"

    puts '1 - взять карту'
    puts '2 - вскрыть карты (закончить игру)'
    puts '3 - пропустить ход'
    print 'Ваш ответ: '
    i = gets.to_i
    game_result if i == 2
    begin
      game.players_turn(i)
    rescue RuntimeError => e
      puts e.message
      puts 'Игра окончена!'
      game_result
    end
    dealers_turn
  end

  def dealers_turn
    begin
      game.dealers_turn
    rescue RuntimeError => e
      puts e.message
      puts 'Игра окончена!'
      game_result
    end
    players_turn
  end

  def game_result
    winner = game.winner
    puts "\n\nКарты дилера:"
    i = 1
    game.dealer.cards.each do |card|
      puts "\tКарта №#{i}: #{card.value}#{card.suit}"
      i += 1
    end
    puts "Количество очков дилера: #{game.dealer.score}"
    puts "\n\nВаши карты:"
    i = 1
    game.player.cards.each do |card|
      puts "\tКарта №#{i}: #{card.value}#{card.suit}"
      i += 1
    end
    puts "Ваше количество очков: #{game.player.score}"
    if winner.nil?
      puts 'Ничья!'
    else
      puts "\nПобедил #{winner.class}!"
      game.game_result!
    end
    puts 'Хотите сыграть еще?'
    puts '1 - да'
    puts '2 - нет'
    print 'Ваш ответ: '
    i = gets.to_i
    case i
    when 1
      play_again
    when 2
      abort 'До свидания!'

    end
  end

  def play_again
    begin
      game.play_again(name)
    rescue RuntimeError => e
      puts e.message
      puts 'Продолжать играть больше нельзя!'
      return nil
    end
    puts "\n\n\tВаш баланс:#{game.player.bank}"
    puts "\tБаланс дилера:#{game.dealer.bank}"
    players_turn
  end
end

int = Interface.new

