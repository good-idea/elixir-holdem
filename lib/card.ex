require Constants

defmodule Card.PlayingCard do
  @enforce_keys [:value, :suit, :name]
  defstruct [:value, :suit, :name]
end

defmodule Card do
  @doc """
  Returns a playing card.

  """
  def create(suit, value) do
    name = elem(Constants.names, value - 1)
    %Card.PlayingCard{suit: suit, value: value, name: name}
  end

  # --- Rendering --- #

  @doc """
  renders a small card as a string

  ## Example
    iex> card = Card.create(:hearts, 1)
    iex> Card.render_small(card)
    "A♥"
  """
  def render_small(card) do
    get_shorthand card
  end

  @doc """
  renders a list of cards as a string

  ## Example
  #
    iex(3)> cards = [Card.create(:hearts, 1), Card.create(:diamonds, 12)]
    iex(4)> Card.render_small_hand(cards)
    "A♥ K♦"
  """
  def render_small_hand(cards) do
    cards
    |> Enum.map(&Card.render_small/1)
    |> Enum.join(" ")
  end

  defp get_printable_card card do
    s = get_suit(card)
    v = get_value_short(card)
    [
      "⎡#{s}    ⎤",
      "⎢     ⎥",
      "⎢  #{v}  ⎥",
      "⎢     ⎥",
      "⎣    #{s}⎦"
    ]

  end

  def render(card) do
    card
    |> get_printable_card
    |> Putser.print_lines
  end

  def render_hand(cards) do
    printables = Enum.map(cards, &get_printable_card/1)
    all_lines = for line <- 0..4 do
      for p <- printables do
        Enum.at(p, line)
      end |> Enum.join(" ")
    end
    Putser.print_lines all_lines

  end

  defp get_suit(card) do
    Constants.suit_symbols(card.suit)
  end

  defp get_value_short(card) do
    case card.value do
      1 -> Constants.value_shorthands(:ace)
      10 -> Constants.value_shorthands(:jack)
      11 -> Constants.value_shorthands(:queen)
      12 -> Constants.value_shorthands(:king)
      _ -> card.value
    end
  end

  defp get_shorthand(card) do
    v = get_value_short(card)
    s = get_suit(card)
    "#{v}#{s}"
  end

end
