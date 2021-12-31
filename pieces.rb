class Piece
  attr_reader :owner,:icon
  def initialize(owner)
    @owner=owner
  end

  def print_piece(background) #background is 41 or 46
    print "\e[#{background}m\e[#{@owner.color}m#{@icon}\e[0m"
  end

  def same_owner(current,target)
    targ_sq=@owner.board[target[0]][target[1]]
    if targ_sq=='#'; return true; end
    if @owner.board[current[0]][current[1]].owner==@owner.board[target[0]][target[1]].owner;
       return true;
    end
    false
  end
end

class Knight < Piece
  def initialize(owner)
    super(owner)
    @icon="N"
  end
  def valid_moves(current,target)
    if ((target[0]-current[0])==1||(target[0]-current[0])==-1)&&((target[1]-current[1])==2||(target[1]-current[1])==-2) 
      return true
    end
    if ((target[0]-current[0])==2||(target[0]-current[0])==-2)&&((target[1]-current[1])==1||(target[1]-current[1])==-1) 
      return true
    end; 
    return false; 
  end
end

class Queen < Piece
  def initialize(owner)
    super(owner)
    @icon="Q"
  end
end

class King < Piece
  def initialize(owner)
    super(owner)
    @icon="K"
  end
end

class Bishop < Piece
  def initialize(owner)
    super(owner)
    @icon="B"
  end

  def valid_moves(current,target)
    if same_owner(current,target); return false; end
    x_diff=current[0]-target[0]
    y_diff=current[1]-target[1]
    if ((x_diff).abs)!=(y_diff).abs
      return false
    end
    i=1
    j=1
    if x_diff>0
      i=-1
    end
    if y_diff>0
      j=-1
    end
    start=1
    while start<x_diff.abs
      if @owner.board[current[0]+i*start][current[1]+j*start]!='#'
        return false
      end
      start+=i
    end
    true
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
  end
end