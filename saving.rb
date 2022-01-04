require './pieces.rb'
require './player.rb'
require 'json'

module BoardSnL
  def save
    obj={}
    obj[:current]=@current_player.color_name
    obj[:white]=self.save_player(@white)
    obj[:black]=self.save_player(@black)
    obj
  end

  def save_player(player)
    piece_array=[]
    player.pieces.each {|piece| 
      piece_array.push([piece.icon,piece.location])
    }
    piece_array
  end

  def save_game_prompt()
    gson=self.save.to_json
    puts "How would you like to name your file?"
    filename=gets.tr("\\\n","")
    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename="saves/#{filename}.json"
    File.open(filename,'w') do |file|
      file.puts gson
    end
  end

  def load(obj)
    build_player_piece_list(@white,:white,obj)
    build_player_piece_list(@black,:black,obj)
  end

  def build_player_piece_list(player,mask,obj)
    obj[player.color_name].each {|piece| 
      case piece[0]
      when "N"
        unit=Knight.new(player,piece[1])
      when "P"
        unit=Pawn.new(player,piece[1])
      when "K"
        unit=King.new(player,piece[1])
        player.king=unit
      when "Q"
        unit=Queen.new(player,piece[1])
      when "B"
        unit=Bishop.new(player,piece[1])
      when
        unit=Rook.new(player,piece[1])
      end
      player.pieces.push(unit)
      @board[piece[1][0]][piece[1][1]]=unit
    }
  end
end