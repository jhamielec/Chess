require './pieces.rb'

class Board
  attr_reader :white,:black,:current_player,:board
  def initialize
    @board=Array.new(8)
    @board.each_with_index {|item,index| @board[index]=Array.new(8,'#')}
    @white=Player.new(37,@board,"white")
    @black=Player.new(30,@board,"black")
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

  def convert_move(move)
    x=move[0].ord-65
    y=56-move[1].ord
    [y,x]
  end

  def get_move(opt='')
    return_arry=[]
    while true
      print "\nWhich piece would you like to move#{opt}? "
      move=gets.tr("\n","")
      if move.length!=2; puts "Not enough Letters";  next;  end
      move.upcase!
      if move[0]<'A'||move[0]>'H'; puts "Invalid Letter"; next; end
      if move[1]<'1'||move[1]>'8'; puts "Invalid Number"; next; end
      return convert_move(move)
    end  
  end
  
  def same_owner(current,target)
    targ_sq=@board[target[0]][target[1]]
    if targ_sq=='#'; return false; end
    if @board[current[0]][current[1]].owner==@board[target[0]][target[1]].owner;
      puts "same owner"
      return true;
    end
    false
  end

  def not_current(move)
    if @board[move[0]][move[1]]=='#'; return false; end
    @current_player==@board[move[0]][move[1]].owner
  end

  def get_player_piece()
    valid=false
    while valid==false
      move=get_move()
      valid=not_current(move)
      if !valid; puts "You must select one of your pieces.";end
    end
    return move
  end

  def get_player_target()
    valid=false
    while valid==false
      move=get_move(" to")
      valid=!not_current(move)
      if !valid; puts "You must select a valid square."; end
    end
    return move
  end

  def update_board(current,target)
    @board[target[0]][target[1]]=@board[current[0]][current[1]]
    @board[current[0]][current[1]]='#'
  end

  def player_turn()
    valid=false
    while !valid
      current=get_player_piece()
      target=get_player_target()
      valid=try_move(current,target)
      puts valid
    end
    update_board(current,target)
    draw_board()
  end



  def try_move(current,target)
    # print "\n#{current} "
    # if @board[current[0]][current[1]]!='#'
    #   print "#{@board[current[0]][current[1]].owner.color_name} #{@board[current[0]][current[1]].icon}"
    # end
    # print "\n#{target} "
    # if @board[target[0]][target[1]]!='#'
    #   puts "#{@board[target[0]][target[1]].owner.color_name} #{@board[target[0]][target[1]].icon}"
    # end
    if same_owner(current,target); return false; end    
    if !@board[current[0]][current[1]].valid_moves(current,target); return false; end
    return true;
  end
end

class Player
  attr_reader :color,:board,:color_name
  attr_accessor :king
  def initialize(color_code,board,color_name)
    @color=color_code
    @board=board
    @color_name=color_name
  end
end


board=Board.new
board.draw_board
board.player_turn