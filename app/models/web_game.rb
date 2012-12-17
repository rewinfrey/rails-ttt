class WebGame < ActiveRecord::Base
  attr_accessible :game
  serialize :game

  def current_player_ai?
    game.current_player.class.to_s =~ (/ai/i)
  end

  def process_move(move)
    mark_move(move)
    switch_player
    save
  end

  def mark_move(move)
    game.mark_move(move, game.current_player.side)
  end

  def switch_player
    game.switch_player
  end

  def valid_move?(move)
    game.valid_move?(move) && game.board.free?(move)
  end

  def finished?
    game.board.finished?
  end

  def winner?
    game.board.winner?
  end

  def draw_game?
    game.board.draw_game?
  end

  def winner
    game.current_player.side == "x" ? "Player 2" : "Player 1"
  end
end
