require './pieces.rb'
require './saving.rb'
require './player.rb'

class Board
  include BoardSnL
  attr_reader :white,:black,:current_player,:board
  def initialize(obj=nil)
    @board=Array.new(8)
    @board.each_with_index {|item,index| @board[index]=Array.new(8,'#')}
    @white=Player.new(37,@board,"white")
    @black=Player.new(30,@board,"black")
    if !obj.nil?
      load(obj)
      return
    end
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
      return @black
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
      [0,7].each {|j| 
        @board[i][j]=Rook.new(@current_player,[i,j]);
        @current_player.pieces.push(@board[i][j])
      }
      [1,6].each {|j| 
        @board[i][j]=Knight.new(@current_player,[i,j]); 
        @current_player.pieces.push(@board[i][j])
      }
      [2,5].each {|j| 
        @board[i][j]=Bishop.new(@current_player,[i,j]);
        @current_player.pieces.push(@board[i][j])
      }
      @board[i][3]=Queen.new(@current_player,[i,3])
      @current_player.pieces.push(@board[i][3])
      @board[i][4]=King.new(@current_player,[i,4])
      @current_player.pieces.push(@board[i][4])
      @current_player.king=@board[i][4]
      }
    
    [1,6].each {|i|
      swap_players()
      0.upto(7) {|j|
        @board[i][j]=Pawn.new(@current_player,[i,j]); 
        @current_player.pieces.push(@board[i][j])}}
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
      move.upcase!
      if move=="SAVE"; save_game_prompt(); return "SAVE"; end
      if move.length!=2; puts "Not enough Letters";  next;  end
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
      if move=="SAVE"; return "SAVE"; end
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
    @board[current[0]][current[1]].location=target
    @board[current[0]][current[1]]='#'
  end

  def get_target_old(target)
    @board[target[0]][target[1]]
  end

  def try_move(current,target)
    if same_owner(current,target); return false; end    
    if !@board[current[0]][current[1]].valid_moves(current,target); return false; end
    return true;
  end

  def replace_piece(old,target)
    @board[target[0]][target[1]]=old
  end

  def player_turn()
    valid=false
    while !valid
      while !valid
        current=get_player_piece()
        if current=="SAVE"; return current; end
        target=get_player_target()
        if target=="SAVE"; return target; end
        valid=try_move(current,target)
      end
      old=get_target_old(target)
      if (old!='#')&&(old.icon=="K"); puts "#{current_player.color_name} wins!"; return true; end;
      update_board(current,target)
      valid=!is_check?(other_player(),@current_player,old)
      if !valid;
        update_board(target,current)
        replace_piece(old,target)
        puts "Invalid. Move would put you in check."
        draw_board()
        next
      end
      if is_check?(@current_player,other_player())
        puts "check"
      end
    end
    draw_board()
    swap_players()
    return false
  end

  def play_game
    draw_board()
    game_over=false
    while !game_over
      game_over=player_turn()
      if game_over=="SAVE"; return; end
    end
  end

  def is_check?(player,king_player,old=nil)
    player.pieces.each {|piece| 
      if piece==old; next; end;
      if piece.valid_moves(piece.location,king_player.king.location); 
        return true;
      end
    }
    false
  end
end

#board.play_game