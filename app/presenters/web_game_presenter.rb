module WebGamePresenter
  def self.for(board)
    klass = case board
            when TTT::ThreeByThree        then ThreeByThree
            when TTT::FourByFour          then FourByFour
            when TTT::ThreeByThreeByThree then ThreeByThreeByThree
            else
              raise ArgumentError, "Unknown board: #{board.inspect}"
            end
    klass.new board: board
  end

  class Base
    def initialize(options)
      self.board = options.fetch :board
    end

    private
    attr_accessor :board
  end

  class ThreeByThree < Base
    def show_board
      html_string = "<table style='width: 300px;'><tr>"
      board[].each_with_index do |square, index|
        html_string += "</tr><tr>" if index % 3 == 0 && index != 0
        if square == " "
          html_string += %Q(<td id="#{index}" style="font-size: 30px; line-height: 12px;" class="square">#{index}</td>)
        else
          html_string += %Q(<td id="#{index}" class="square">#{square}</td>)
        end
      end
      html_string += "</tr></table>"
    end
  end

  class FourByFour < Base
    def show_board
      html_string = "<table style='width: 300px;'><tr>"
      board[].each_with_index do |square, index|
        html_string += "</tr><tr>" if index % 4 == 0 && index != 0
        if square == " "
          html_string += %Q(<td id="#{index}" style="font-size: 30px; line-height: 12px;" class="square">#{index}</td>)
        else
          html_string += %Q(<td id="#{index}" class="square">#{square}</td>)
        end
      end
      html_string += "</tr></table>"
    end
  end

  class ThreeByThreeByThree < Base
    def show_board
      html_string = ""
      board[].each_slice(9).with_index do |board_level, board_level_index|
        html_string += "<table style='display: inline-block; width: 300px;'><tr>"
        board_level.each_with_index do |square, index|
          html_string += "</tr><tr>" if index % 3 == 0 && index != 0
          if square == " "
            html_string += %Q(<td id="#{index + (board_level_index * 9)}" style="font-size: 30px; line-height: 12px;" class="square">#{index + (board_level_index * 9)}</td>)
          else
            html_string += %Q(<td id="#{index}" class="square">#{square}</td>)
          end
        end
        html_string += "</tr></table>"
      end
      html_string
    end
  end
end
