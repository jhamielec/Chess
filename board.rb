require './pieces.rb'

class Board
  attr_reader :white,:black,:current_player,:board
  def initialize
    @board=Array.new(8)
    @board.each_with_index {|item,index| @board[index]=Array.new(8,'#')}
    @white=Player.new(37,@board)
    @black=Player.new(30,@board)
    @current_player=@white
    init_board()
  end

  def swap_players
    @current_player=other_player()
  end

  def other_player
    if @current_player==@black
      return @white
    else
      @current_player=@black
    end
  end

  def draw_board
    @board.each_with_index {|row,row_index| 
      print "#{8-row_index} "
      row.each_with_index {|square,col_index| 
      if square=='#'
        print "\e[#{41+5*((row_index+col_index)%2)}m \e[0m"
      else 
        @board[row_index][col_index].print_piece(41+5*((row_index+col_index)%2))
      end
      }
      print "\n"}
    print "0 ABCDEFGH\n"
  end


  def same_owner(current,target)
    targ_sq=@board[target[0]][target[1]]
    if targ_sq=='#'; return true; end
    if @board[current[0]][current[1]].owner==@board[target[0]][target[1]].owner;
       return true;
    end
    false
  end

  def try_move(current,target)
    if same_owner(current,target); return false; end    
    return @board[current[0]][current[1]].valid_moves(current,target)
  end


  private def init_board()
    [0,7].each {|i|
      swap_players()
      [0,7].each {|j| @board[i][j]=Rook.new(@current_player)}
      [1,6].each {|j| @board[i][j]=Knight.new(@current_player)}
      [2,5].each {|j| @board[i][j]=Bishop.new(@current_player)}
      @board[i][3]=Queen.new(@current_player)
      @board[i][4]=King.new(@current_player)
      @current_player.king=@board[i][4]
      }
    
    [1,6].each {|i|
      swap_players()
      0.upto(7) {|j|
        @board[i][j]=Pawn.new(@current_player)}}
  end

end

class Player
  attr_reader :color,:board
  attr_accessor :king
  def initialize(color_code,board)
    @color=color_code
    @board=board
  end
end


board=Board.new
board.draw_board
puts board.try_move([7,2],[6,3])
puts board.try_move([7,0],[4,0])
puts board.try_move([7,0],[4,4])
puts board.try_move([7,0],[7,1])

