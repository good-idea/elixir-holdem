defmodule Constants do
  use Const
  const suits, do: [:hearts, :diamonds, :spades, :clubs]
  const names, do: {
    "Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Jack", "Queen", "King"
  }
  enum suit_symbols do
    hearts "♥"
    diamonds "♦"
    clubs '♣'
    spades '♠'
  end
  enum value_shorthands do
    ace "A"
    jack "J"
    queen "Q"
    king "K"
  end
  enum suit_names do
    hearts "Hearts"
    diamonds "Diamonds"
    clubs "Clubs"
    spades "Spades"
  end
end
