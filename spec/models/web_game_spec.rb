require 'spec_helper'

describe WebGame do
  let(:game) { TTT::Game.new(board: TTT::ThreeByThree.new, player1: TTT::Human.new, player2: TTT::AIEasy.new) }
  let(:web_game) { WebGame.new(game: game) }
  describe "current_player_ai?" do
    it "returns nil when a game's current_player is not an AI" do
      web_game.current_player_ai?.should == nil
    end

    it "returns an integer when a game's current_player is an AI" do
      web_game.game.current_player = web_game.game.player2
      web_game.current_player_ai?.should_not == nil
    end
  end

  describe "mark_move" do
    it "marks a valid move on the game board" do
      web_game.mark_move(1)
      web_game.game.board.board[1].should_not == " "
    end
  end

  describe "swtich_player" do
    it "switches the game's current player to the other player" do
      web_game.game.current_player = web_game.game.player1
      web_game.switch_player
      web_game.game.current_player.equal?(web_game.game.player2)
      web_game.switch_player
      web_game.game.current_player.equal?(web_game.game.player1)
    end
  end

  describe "valid_move?" do
    it "returns true if a newly inputted move is valid (exists in the range of the board) and also is an empty square on the board" do
      web_game.valid_move?(1).should == true
    end

    it "returns false if a newly inputted move is out of the range of the game board" do
      web_game.valid_move?(100).should == false
    end

    it "returns false if a newly inputted move is a square that is already occuppied on the game board" do
      web_game.game.board.board[1] = "x"
      web_game.valid_move?(1).should == false
    end
  end
end
