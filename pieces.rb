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
    if x_diff.abs>1; return false; end
    y_diff=current[1]-target[1]
    if y_diff.abs>1; return false; end
    return true
  end
end

module BishopMoves
  def bishop_moves(current,target)
    x_diff=current[0]-target[0]
    y_diff=current[1]-target[1]
    if ((x_diff).abs)!=(y_diff).abs
      return false
    end
    i=1
    j=1
    if x_diff>0;i=-1; end
    if y_diff>0; j=-1; end
    pos=1
    while pos<x_diff.abs
      if @owner.board[current[0]+i*pos][current[1]+j*pos]!='#'
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
    if (x_diff!=0)&&(y_diff!=0); return false; end;
    i,pos=1
    if (x_diff<0)||(y_diff<0); i=-1; end;
    if x_diff!=0;
      while pos<x_diff.abs
        if @owner.board[current[0]+i*pos][current[1]]!='#'; return false; end
        pos+=1
      end
      return true
    end
    while pos<y_diff.abs
      if @owner.board[current[0]+i*pos][current[1]]!='#'; return false; end
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