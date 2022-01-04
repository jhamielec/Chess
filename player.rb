class Player
  attr_reader :color,:board,:color_name
  attr_accessor :king,:pieces
  def initialize(color_code,board,color_name)
    @color=color_code
    @board=board
    @color_name=color_name
    @pieces=[]
  end

end