class GamesController < ApplicationController

  def new
    require 'pry'
    binding.pry
    @hard_ai = TTT::HardAI.new
  end

  def index
    require 'pry'
    binding.pry
  end
end
