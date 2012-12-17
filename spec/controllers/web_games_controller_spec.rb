require 'spec_helper'

describe WebGamesController do
  let(:game) { TTT::Game.new(board: TTT::ThreeByThree.new, player1: TTT::Human.new, player2: TTT::AIEasy.new) }

  describe "GET new" do
    it "sets the player options and the board options for creating a new game" do
      get :new
      assigns[:player_options].should == [TTT::Human, TTT::AIEasy, TTT::AIMedium, TTT::AIHard]
      assigns[:board_options].should == [TTT::ThreeByThree, TTT::FourByFour, TTT::ThreeByThreeByThree]
    end
  end

  describe "POST create" do
    before(:each) do
      @web_game = mock_model(WebGame)
    end
    it "creates a new web game" do
      @web_game.stub(:save).and_return(true)
      WebGame.should_receive(:new).and_return(@web_game)
      post :create, player1: TTT::Human, player2: TTT::Human, board: TTT::ThreeByThree
    end

    context "after instantiating a new web game" do
      before(:each) do
        WebGame.should_receive(:new).and_return(@web_game)
        @web_game.stub(:id).and_return(1)
      end

      context "and the save is successful" do
        before(:each) do
          @web_game.should_receive(:save).and_return(true)
        end

        it "saves the web game" do
          post :create, player1: TTT::Human, player2: TTT::Human, board: TTT::ThreeByThree
        end

        it "sets cookies[:game_id] to web_game.id" do
          post :create, player1: TTT::Human, player2: TTT::Human, board: TTT::ThreeByThree
          cookies[:game_id].should == @web_game.id
        end

        it "redirects to the web_game's show page" do
          post :create, player1: TTT::Human, player2: TTT::Human, board: TTT::ThreeByThree
          redirect_to @web_game
        end
      end

      context "and the save is unsuccessful" do
        before(:each) do
          @web_game.should_receive(:save).and_return(false)
          post :create, player1: TTT::Human, player2: TTT::Human, board: TTT::ThreeByThree
        end

        it "sets flash[error]" do
          flash[:error].should_not == ""
        end

        it "redirects to 'new'" do
          redirect_to action: "new"
        end
      end
    end
  end

  describe "GET index" do
    it "redirects the user to a previously started game if one is found in the cookies" do
      web_game      = WebGame.new(game: game)
      web_game.save
      cookies[:game_id] = web_game.id
      get :index
      redirect_to WebGame.find_by_id(cookies[:game_id])
    end

    it "redirects the user to new if no game_id is found in cookies" do
      get :index
      redirect_to action: "new"
    end

    it "redirects the user to index if no game_id is found in cookies" do
      get :index
      redirect_to action: "index"
    end
  end

  describe "PUT mark_move" do
    before(:each) do
      @web_game = WebGame.new(game: game)
      @web_game.game.player1.side = "x"
      @web_game.game.player2.side = "o"
      @web_game.save
    end

    it "finds the existing game in the db" do
      put :mark_move, id: @web_game.id
      response.should redirect_to @web_game
    end

    context "a valid move is sent" do
      it "marks the board with the move" do
        put :mark_move, { id: @web_game.id, move: "0" }
        assigns(:web_game).game.board.board[0].should_not == " "
      end

      it "switches the current player" do
        put :mark_move, { id: @web_game.id, move: "0" }
        assigns(:web_game).game.current_player.side.should == "o"
      end
    end

    context "an invalid move is sent" do
      before(:each) do
        @web_game.game.board.board[0] = "x"
        put :mark_move, { id: @web_game.id, move: "0" }
      end

      it "does not switch the current player" do
        assigns(:web_game).game.current_player.side == @web_game.game.player1.side
      end

      it "redirects to the show page and prompts for the move again" do
        response.should redirect_to @web_game
      end
    end
  end

  describe "GET show" do
    before(:each) do
      @web_game = WebGame.new(game: game)
      @web_game.game.player1.side = "x"
      @web_game.game.player2.side = "o"
      @web_game.save
    end

    it "sends a flash message prompting the current player to move" do
      get :show, id: @web_game.id
      flash[:notice].should == "Player 1 turn"
    end

    it "sends a next_move message to the game if the current player is an AI" do
      web_game = WebGame.find_by_id(@web_game.id)
      web_game.switch_player
      web_game.save
      get :show, id: @web_game.id
      assigns(:web_game).game.player2.available_moves.length == 8
    end
  end

  describe "eval_board" do
    before(:each) do
      @web_game = WebGame.new(game: game)
      @web_game.game.player1.side = "x"
      @web_game.game.player2.side = "o"
      @web_game.save
    end

    it "sets flash[:notice] to 'Player 1 is the winner!' when player 1 wins" do
      controller.instance_eval { eval_board }
    end
  end
end
