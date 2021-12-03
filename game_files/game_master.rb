# frozen_string_literal: true

require_relative 'player'
require_relative 'deck'
require_relative 'dealer'

class GameMaster
  attr_reader :player, :dealer, :deck

  def initialize(player_name)
    @player = Player.new(player_name)
    @dealer = Dealer.new
    @deck = Deck.new
    game_beginning
  end

  def game_beginning
    2.times do
      card = deck.give_card!
      dealer.take_card(card)
    end

    2.times do
      card = deck.give_card!
      player.take_card(card)
    end
  end

  def dealers_turn
    if dealer.score < 17
      card = deck.give_card!
      dealer.take_card(card)
    end
  end

  def players_turn(option)
    case option
    when 1
      card = deck.give_card!
      player.take_card(card)
      raise 'Игра закончена!' if game_end?
    when 2
      raise 'Игра закончена!'
    end
  end

  def game_end?
    return true if player.cards.count == 3

    false
  end

  def winner
    return nil if dealer.score == player.score
    return player if player.score == 21
    return dealer if player.score > 21
    return player if ((player.score > dealer.score) or ((21 - player.score).abs < (21 - dealer.score).abs))

    dealer
  end

  def loser
    return @player if winner == @dealer
    @dealer
  end

  def game_result!
    game_winner = winner
    return nil if game_winner.nil?

    game_loser = loser
    game_winner.bank += 10
    game_loser.bank -= 10
    nil
  end

  def play_again(name)
    raise 'Недостаточно денег в банке!' if @dealer.bank.zero? || @player.bank.zero?

    dealer_bank = @dealer.bank
    player_bank = @player.bank
    @player = Player.new(name, player_bank)
    @dealer = Dealer.new(dealer_bank)
    @deck = Deck.new
    game_beginning
  end
end

