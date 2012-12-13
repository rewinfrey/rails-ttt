class WebGame < ActiveRecord::Base
  attr_accessible :game
  serialize :game
end
