# frozen_string_literal: true

require_relative 'modules'
# класс для игрока
class Player
  include PlayerAndDealerMethods
  attr_reader :name

  def initialize(name, bank = 100)
    @name = name
    @cards = []
    @bank = bank
    @score = 0
  end
end

