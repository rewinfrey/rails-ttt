require 'ruby-ttt/lib/ttt/game'
require 'ruby-ttt/lib/ttt/three_by_three'
require 'ruby-ttt/lib/ttt/four_by_four'
require 'ruby-ttt/lib/ttt/three_by_three_by_three'
require 'ruby-ttt/lib/ttt/human'
require 'ruby-ttt/lib/ttt/ai_easy'
require 'ruby-ttt/lib/ttt/ai_medium'
require 'ruby-ttt/lib/ttt/ai_hard'
require 'ruby-ttt/lib/ttt/web_view'
require 'ruby-ttt/lib/ttt/game_setup'
require 'ruby-ttt/lib/ttt/game_setup_io_interface'
require 'ruby-ttt/lib/ttt/gameio'
require 'ruby-ttt/lib/ttt/board'

class WebGamesController < ApplicationController

  def new
    @player_options = [TTT::Human, TTT::AIEasy, TTT::AIMedium, TTT::AIHard]
    @board_options  = [TTT::ThreeByThree, TTT::FourByFour, TTT::ThreeByThreeByThree]
  end

  def create
    @player1  = params[:player1].constantize.new
    @player2  = params[:player2].constantize.new
    @board    = params[:board].constantize.new
    @game     = TTT::Game.new(board: @board, player1: @player1, player2: @player2)
    @game.player1.side = "x"
    @game.player2.side = "o"
    @web_game = WebGame.new(game: @game)
    if @web_game.save
      cookies[:game_id] = @web_game.id
      flash[:notice] = "Welcome to TTT!"
      redirect_to @web_game
    else
      flash[:error] = "Oops, something went wrong, please try again."
      redirect_to action: "new"
    end
  end

  def display_board
  end

  def index
    if cookies[:game_id]
      redirect_to WebGame.find_by_id(cookies[:game_id])
    else
      redirect_to action: "new"
    end
  end

  def mark_move
    @web_game = WebGame.find_by_id(params[:id])
    @web_game.game.mark_move(params[:move].to_i, @web_game.game.current_player.side)
    @web_game.game.switch_player
    @web_game.save
    redirect_to @web_game
  end

  def show
    @web_game = WebGame.find_by_id(params[:id])
    if curr_player_ai?
      next_move
      return
    else
      if @web_game.game.current_player.side == @web_game.game.player1.side
        flash[:notice] = "Player 1 turn."
      else
        flash[:notice] = "Player 2 turn."
      end
    end
  end

  def curr_player_ai?
   @web_game.game.current_player.class.to_s =~ (/ai/i)
  end

  def next_move
    @web_game.game = @web_game.game.next_move
    @web_game.save
    if @web_game.game.board.finished?
      redirect_to action: "end_game", id: @web_game.id
      return
    else
      if curr_player_ai?
        next_move
        return
      else
        redirect_to @web_game
      end
    end
  end

  def eval_board
    @web_game = WebGame.find_by_id(params[:id])
    if @web_game.game.board.finished?
      redirect_to action: end_game, id: @web_game.id
      return
    else
      redirect_to @web_game
    end
  end

  def end_game
    @web_game = WebGame.find_by_id(params[:id])
  end

  def test_show
    @web_game = WebGame.find_by_id(params[:id])
  end
end
