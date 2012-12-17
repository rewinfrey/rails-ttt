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
    web_game = WebGame.new(game: build_new_game(params))
    if web_game.save
      cookies[:game_id] = web_game.id
      flash[:notice]    = "Welcome to TTT!"
      redirect_to web_game
    else
      flash[:error]     = "Oops, something went wrong, please try again."
      redirect_to action: "new"
    end
  end

  def index
    if cookies[:game_id]
      @webgame = WebGame.find_by_id(cookies[:game_id])

      require "pry"
      binding.pry
      redirect_to WebGame.find_by_id(cookies[:game_id])
    else
      cookies[:game_id] = nil
      redirect_to action: "new"
    end
  end

  def mark_move
    @web_game = WebGame.find_by_id(params[:id])
    @web_game.process_move(params[:move].to_i) if params[:move] && @web_game.valid_move?(params[:move].to_i)
    eval_board
  end

  def show
    @web_game = WebGame.find_by_id(params[:id])
    return next_move if @web_game.current_player_ai?
    flash[:notice] = player1_move? ? "Player 1 turn" : "Player 2 turn"
    @web_game_presenter = WebGamePresenter.for(@web_game.game.board)
  end

  private

  def eval_board
    if @web_game.finished? && @web_game.winner?
      flash[:notice] = "#{@web_game.winner} is the winner!"
    elsif @web_game.finished?
      flash[:notice] = "It's a draw."
    else
      redirect_to @web_game
      return
    end
    cookies[:game_id] = nil
    render "end_game"
  end

  def next_move
    @web_game.game = @web_game.game.next_move
    @web_game.save
    eval_board
  end

  def player1_move?
    @web_game.game.current_player.side == @web_game.game.player1.side
  end

  def build_new_game(params)
    player1  = params[:player1].constantize.new
    player2  = params[:player2].constantize.new
    board    = params[:board].constantize.new
    game     = TTT::Game.new(board: board,
                             player1: player1,
                             player2: player2)
    game.player1.side = "x"
    game.player2.side = "o"
    game
  end
end
