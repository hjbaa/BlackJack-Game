# frozen_string_literal: true

require_relative 'card'

# класс для колоды карт
class Deck
  attr_reader :deck

  def initialize
    @deck = create_deck
  end

  def give_card!
    i = deck.count
    card = deck[rand(0...i)]
    deck.delete(card)
    card
  end

  private

  def create_deck
    temp_arr = []
    [*(2..10), 'В', 'Д', 'К', 'Т'].each do |value|
      %w[♡ ♢ ♧ ♤].each do |suit|
        temp_arr << Card.new(value, suit)
      end
    end
    temp_arr.shuffle

  end
end

