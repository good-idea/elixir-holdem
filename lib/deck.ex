require Constants

defmodule Deck do
  def create do
    for suit <- Constants.suits, value <- 1..12 do
      Card.create(suit, value)
    end
  end

  @doc """
  returns a shuffled deck
  """
  def shuffle deck do
    Enum.shuffle(deck)
  end

  @doc """
  returns a tuple of
  - dealt cards
  - the remaining deck
  """
  def deal deck, hand_size do
    Enum.split(deck, hand_size)
  end
end
