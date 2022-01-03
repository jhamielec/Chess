class Piece
  attr_reader :owner,:icon
  def initialize(owner)
    @owner=owner
  end

  def print_piece(background) #background is 41 or 46
    print "\e[#{background}m\e[#{@owner.color}m#{@icon}\e[0m"
  end

  def valid_moves(current,target)
  end

  def error_log(string)
    puts string
  end

end




class Knight < Piece
  def initialize(owner)
    super(owner)
    @icon="N"
  end
  def valid_moves(current,target)
    x_diff=current[0]-target[0]
    y_diff=current[1]-target[1]
    if (x_diff==1||x_diff==-1)&&(y_diff==2||y_diff==-2) 
      return true
    end
    if (x_diff==2||x_diff==-2)&&(y_diff==1||y_diff==-1) 
      return true
    end; 
    error_log("knight illegal")
    return false; 
  end
end



class King < Piece
  def initialize(owner)
    super(owner)
    @icon="K"
  end
  def valid_moves(current,target)
    x_diff=current[0]-target[0]
    if x_diff.abs>1; error_log("king x_diff");return false; end
    y_diff=current[1]-target[1]
    if y_diff.abs>1;  error_log("king y_diff"); return false; end
    return true
  end
end

module BishopMoves
  def bishop_moves(current,target)
    x_diff=current[0]-target[0]
    y_diff=current[1]-target[1]
    if ((x_diff).abs)!=(y_diff).abs;  error_log("bishop off diagonal"); return false;end
    i=1
    j=1
    if x_diff>0;i=-1; end
    if y_diff>0; j=-1; end
    pos=1
    while pos<x_diff.abs
      if @owner.board[current[0]+i*pos][current[1]+j*pos]!='#'
        error_log("piece between current and target")
        return false
      end
      pos+=i
    end
    true
  end
end

class Bishop < Piece
  include BishopMoves
  def initialize(owner)
    super(owner)
    @icon="B"
  end

  def valid_moves(current,target)
    return bishop_moves(current,target)
  end
end

class Pawn < Piece
  def initialize(owner)
    super(owner)
    @icon="P"
  end

  def valid_moves(current,target)
    color=@owner.color_code
    move=1
    if color=="white"; move=-1; end
    x_diff=current[0]-target[0]
    y_diff=current[1]-target[1]
    if (x_diff>1)||(x_diff<-1); error_log("#{color} pawn x_diff"); return false; end
    if (x_diff!=0)
      if @owner.board[target[0]][target[1]]=='#'; error_log("#{color} pawn can't attack empty"); return false; end
      if y_diff!=move; error_log("#{color} attacking too far"); return false; end
      return true
    end
    if (y_diff.abs>2); error_log("#{color} pawn y_diff"); return false; end
    if (current[1]!=6)&&(y_diff!=move); error_log("#{color} pawn too far"); return false; end
    if (y_diff==2*move);
      if (@owner.board[current[0]+move][current[1]]!='#')&&((@owner.board[current[0]+2*move][current[1]]!='#')); 
        error_log("#{color} illegal double pawn move"); 
        return false;
      end
      return true
    end;

  end
end

class Rook < Piece
  def initialize(owner)
    super(owner)
    @icon="R"
  end

  def valid_moves(current,target)
    return rook_moves(current,target)
  end
end

module RookMoves
  def rook_moves(current,target)
    x_diff=current[0]-target[0]
    y_diff=current[1]-target[1]
    if (x_diff!=0)&&(y_diff!=0); error_log("rook off of xy axes"); return false; end;
    i,pos=1
    if (x_diff<0)||(y_diff<0); i=-1; end;
    if x_diff!=0;
      while pos<x_diff.abs
        if @owner.board[current[0]+i*pos][current[1]]!='#'; error_log("rook horizontal piece in way");return false; end
        pos+=1
      end
      return true
    end
    while pos<y_diff.abs
      if @owner.board[current[0]+i*pos][current[1]]!='#'; error_log("rook vertical piece in way"); return false; end
      pos+=1
    end
    return true
  end
end

class Queen < Piece
  include RookMoves
  include BishopMoves
  def initialize(owner)
    super(owner)
    @icon="Q"
  end
  def valid_moves(current,target)
    return rook_moves(current,target)||(bishop_moves(current,target))
  end
end