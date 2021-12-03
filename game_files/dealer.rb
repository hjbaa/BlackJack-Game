# frozen_string_literal: true

require_relative 'deck'
require_relative 'modules'

# класс для дилера
class Dealer
  include PlayerAndDealerMethods

  def initialize(bank = 100)
    @cards = []
    @score = 0
    @bank = bank
  end

end

