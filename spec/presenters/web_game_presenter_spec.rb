require 'web_game_presenter'
require 'ttt/three_by_three'
require 'ttt/four_by_four'
require 'ttt/three_by_three_by_three'

describe WebGamePresenter do
  def show_board(presenter)
    string = presenter.show_board.scan(/<td|<tr|>[xo0-9]+</).join
    string.delete! "><"
    string
  end

  def presenter_for(klass, updates)
    board = klass.new
    updates.each { |index, marker| board.update index, marker }
    presenter = described_class.new board: board
  end

  it 'renders a three_by_three board' do
    presenter = presenter_for TTT::ThreeByThree, 0 => 'x', 1 => 'o'
    show_board(presenter).should == "tr" "tdx" "tdo" "td2" \
                                    "tr" "td3" "td4" "td5" \
                                    "tr" "td6" "td7" "td8"
  end

  it 'renders a four_by_four board' do
    presenter = presenter_for TTT::FourByFour, 0 => 'x', 1 => 'o'
    show_board(presenter).should == "tr" "tdx" "tdo" "td2" "td3" \
                                    "tr" "td4" "td5" "td6" "td7" \
                                    "tr" "td8" "td9" "td10" "td11" \
                                    "tr" "td12" "td13" "td14" "td15"

  end

  it 'renders a three_by_three_by_three board' do
    presenter = presenter_for TTT::ThreeByThreeByThree, 0 => 'x', 1 => 'o'
    show_board(presenter).should == "tr" "tdx" "tdo" "td2" \
                                    "tr" "td3" "td4" "td5" \
                                    "tr" "td6" "td7" "td8" \
                                    \
                                    "tr" "td9" "td10" "td11" \
                                    "tr" "td12" "td13" "td14" \
                                    "tr" "td15" "td16" "td17" \
                                    \
                                    "tr" "td18" "td19" "td20" \
                                    "tr" "td21" "td22" "td23" \
                                    "tr" "td24" "td25" "td26" \
  end
end
