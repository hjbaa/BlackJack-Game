# frozen_string_literal: true

# модуль для общих методов игрока и дилера
module PlayerAndDealerMethods
  attr_reader :cards, :score
  attr_accessor :bank

  def take_card(card)
    @cards << card
    score_calculation
  end

  def skip_turn
    nil
  end

  private

  def score_calculation
    temp_score = 0
    ace_counter = 0
    @cards.each do |card|
      ace_counter += 1 if card.value == 'Т'
    end
    case ace_counter
    when 0
      cards.each do |card|
        temp_score += value_of_card(card)
      end

    when 1 # 1 туз в руке
      cards.reject { |card| card.value == 'Т' }.each do |card|
        temp_score += value_of_card(card)
      end

      temp_score += if 21 - temp_score < 11
                      1
                    else
                      11
                    end

    when 2 # 2 туза в руке
      if cards.count == 2 # если из двух карт - два туза, то наиболее близкий счет к 21 - 12 (11 + 1)
        temp_score += 12
      else
        temp_score += value_of_card(cards.find { |card| card.value != 'Т' })
        temp_score += if 21 - temp_score < 12
                        2 # 1 + 1
                      else
                        12 # 11 + 1
                      end
      end

    else # когда все три карты - тузы, лучшим вариантом будет 13 очков (11 + 1 + 1)
      temp_score += 13
    end
    @score = temp_score
  end

  def value_of_card(card)
    if %w[В Д К].include?(card.value)
      10
    else
      card.value
    end
  end
end

