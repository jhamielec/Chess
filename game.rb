require './board.rb'
require 'json'

def brand_new_game
  puts "New game started"
  board=Board.new()
  board.play_game
end

def load_game
  puts "Enter the game you would like to load: "
  obj=nil
  while obj.nil?
    obj=JSON.parse(File.read("saves/#{gets.tr("\\\n","")}.json"))
  end
  Board.new(obj)
end

def load_and_play()
  load_game.play_game
end

def choose_mode()
  answer=gets.tr("\\\n","")
  if (answer!='1')&&answer!='2'&&answer!='3'
    return nil
  end
  answer
end

def start_game()
  puts "Do you want to:\n(1) Play a new game \n(2) Play a saved game\n(3) Exit"
  answer=nil
  while answer.nil? do
    answer=choose_mode()
  end
  if answer=='1'
    brand_new_game()
  elsif answer=='2'
    load_and_play()
  end
end

start_game()