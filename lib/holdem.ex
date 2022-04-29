defmodule Holdem.Game do
  @enforce_keys [:deck, :players, :turn, :round]
  defstruct [:deck, :players, :turn, :round, :burns, :community]
end

defmodule Holdem.Player do
  @enforce_keys [:position, :hand, :chips]
  defstruct [:position, :hand, :chips, :current_bet]
end

defmodule Holdem do
  def start(num_players) do
    { deck, players } =
      Deck.create
      |> Deck.shuffle
      |> deal_hands(num_players)
    await_action %Holdem.Game{deck: deck, players: players, burns: [], community: [], turn: 1, round: 1 }
  end

  defp get_current_player game do
    case game.turn do
      0 -> :dealer
      _ -> Enum.at(game.players, game.turn - 1)
    end
  end

  defp deal_hands deck, num_players do
    for position <- 1..num_players, reduce: {deck, []} do
      {deck, players} ->
        { hand, remainder } = Deck.deal(deck, 2)
        player = %Holdem.Player{position: position, hand: hand, chips: 100}
        { remainder, players ++ [player] }
    end
  end

  defp increment_turn %Holdem.Game{ turn: turn, round: round, players: players } = game do
    new_turn = case turn == length(players) do
      true -> 0
      _ -> turn + 1
    end
    # If the new turn is 0, it's the dealer.
    # Inrement the round.
    new_round = case new_turn do
      0 -> round + 1
      _ -> round
    end
    %Holdem.Game{ game | turn: new_turn, round: new_round }
  end

  defp await_action game do
    print_game game
    game = case game.turn do
      0 -> await_dealer game
      _ -> await_player game
    end
    game |> increment_turn |> await_action
 end

  defp await_dealer game do
   move = Prompt.ask("What's the move?", ["deal"])
    case move do
      "deal" -> dealer_deal game
    end
  end

  # Dealer Moves
  defp dealer_deal game do
    case length(game.community) do
      0 -> deal_community game, 3
      3 -> deal_community game, 1
      4 -> deal_community game, 1
      _ -> game # TODO: end game when it reaches the dealer turn
    end
  end

  defp deal_community %Holdem.Game{ burns: burns, deck: deck, community: community } = game, card_count do
    { burned, deck } = Deck.deal(deck, 1)
    { dealt, deck } = Deck.deal(deck, card_count)
    %Holdem.Game{ game | deck: deck, burns: burns ++ burned, community: community ++ dealt }
  end

  # Player Moves
  defp await_player game do
    Prompt.ask("What's the move?", ["stay", "fold"])
    game
  end


  # Printing
  defp print_game %Holdem.Game{ community: community } = game do
    Putser.clear
    player = get_current_player game
    IO.puts("")
    IO.puts(case player do
      :dealer -> "Dealer's turn"
      _ -> "Player #{player.position}'s turn"
    end)
    IO.puts("")

    IO.puts("Community:")
    Card.render_hand(community)
    case player do
      :dealer -> :ok
      _ ->
        IO.puts("Player #{player.position} hand:")
        Card.render_hand(player.hand)
    end
    game
  end
end
