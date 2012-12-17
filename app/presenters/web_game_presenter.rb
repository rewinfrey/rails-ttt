class WebGamePresenter
  def initialize(options)
    self.board = options[:board]
  end

  def show_board
    case board[].length
    when 9
      return show_three_by_three
    when 16
      return show_four_by_four
    when 27
      return show_three_by_three_by_three
    end
  end

  def show_three_by_three
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

  def show_four_by_four
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

  def show_three_by_three_by_three
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

  private
  attr_accessor :board
end
