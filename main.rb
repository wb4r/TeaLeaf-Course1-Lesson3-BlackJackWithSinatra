require 'rubygems'
require 'sinatra'
require 'pry'

use Rack::Session::Cookie,  :key => 'rack.session',
                            :path => '/',
                            :secret => 'wzjfeno43634245mvaldise9r0373'

# HELPERS

helpers do 

  def create_deck
    suits = %w[H D C S]
    cards = %w[2 3 4 5 6 7 8 9 10 J Q K A]
    deck = suits.product(cards)
    session[:deck] = deck.shuffle!
  end

  def provide_card(hand)
    session[hand] << session[:deck].pop
  end

  def create_hands
    session[:dealer_hand] = []
    session[:player_hand] = []
  end

  def first_hand
    2.times do 
      provide_card(:dealer_hand)
      provide_card(:player_hand)
    end
  end

  def calculate_total(hand)
    total = []
    hand.each do |card|
      if card[1] == 'J' || card[1] == 'Q' || card[1] == 'K' 
        total << 10
      elsif card[1] == 'A' 
        total << 11
      else
        total << card[1].to_i
      end
    end
    while total.inject(:+) > 21 && total.max == 11
      total.sort!
      total.pop
      total << 1
    end
    total.inject(:+)
  end

  def dealer_to_17 
    session[:dealer_total] = calculate_total(session[:dealer_hand])
    while session[:dealer_total] < 17
      provide_card(:dealer_hand)
      session[:dealer_total] = calculate_total(session[:dealer_hand])
    end
    session[:dealer_total]
  end

  def card_image(card) # ['H', '4']
    suit = case card[0]
      when 'H' then 'hearts'
      when 'D' then 'diamonds'
      when 'C' then 'clubs'
      when 'S' then 'spades'
    end

    value = card[1]
    if ['J', 'Q', 'K', 'A'].include?(value)
      value = case card[1]
        when 'J' then 'jack'
        when 'Q' then 'queen'
        when 'K' then 'king'
        when 'A' then 'ace'
      end
    end
    "<img class='img-thumbnail' src='/images/cards/#{suit}_#{value}.jpg'>"
  end
end

# HTTP GET/POST REQUESTS

get '/' do  
  redirect '/user_name'
end

get '/user_name' do
  erb :user_name
end

post '/user_name' do 
  if !params['user_name'].empty?
    session[:user_name] = params['user_name'].capitalize!
    erb :bet_amount
  else
    @error = "Sir/Mam, I need your ID to let you in."
    halt erb(:user_name)
  end
end

post '/bet_amount' do
  if params['bet_amount'].empty? 
    @error = "Want to play with no bet on the table? Not in here.."
    halt erb(:bet_amount)
  elsif params['bet_amount'].to_i > 500
    @error = "Maxim bet permited: 500$"
    halt erb(:bet_amount)
  elsif params['bet_amount'].to_i == 0
    @error = "Wadayamean '#{params['bet_amount']}' ?!?"
    halt erb(:bet_amount)
  else
    session[:bet_amount] = params['bet_amount']
    redirect '/new_game'
  end
end

# IVAR DECLARATIONS AND GAME START

before do 
  @show_hit_or_stay_btn = true
  @show_replay_btn = false
  @show_dealer_data = false
end

get '/new_game' do
  create_deck
  create_hands
  first_hand  
  session[:player_total] = calculate_total(session[:player_hand])
  session[:dealer_total] = calculate_total(session[:dealer_hand])
  erb :game
end

post '/ingame' do
  if calculate_total(session[:player_hand]) < 21
    if params['hit']
      provide_card(:player_hand)
      session[:player_total] = calculate_total(session[:player_hand])
      if session[:player_total] < 21
        redirect '/ingame'
      elsif session[:player_total] > 21
        redirect '/busted'
      elsif session[:player_total] == 21
        redirect '/player_won'
      end      
    elsif params['stay']
      dealer_to_17
      redirect '/stayed'
    end
  else
    redirect '/player_won'
  end
end

get '/ingame' do 
  @show_replay_btn = false
  @show_hit_or_stay_btn = true
  erb :game
end

# INGAME OPTIONS AND RESULTS

get '/stayed' do 
  @show_dealer_data = true
  session[:player_total] = calculate_total(session[:player_hand])
  session[:dealer_total] = calculate_total(session[:dealer_hand])
  if session[:player_total] <= session[:dealer_total] && session[:dealer_total] < 21
    redirect '/dealer_won'
  else
    redirect '/player_won'
  end
  @show_replay_btn = true
  @show_hit_or_stay_btn = false
  erb :game
end

get '/busted' do
  @show_replay_btn = true
  @show_hit_or_stay_btn = false
  @error = "Sorry, you busted"
  erb :game 
end

get '/player_won' do 
  @show_dealer_data = true
  @show_replay_btn = true
  @show_hit_or_stay_btn = false
  @show_player_won = "#{session[:user_name]} won this time!"
  erb :game
end

get '/dealer_won' do 
  @show_dealer_data = true
  @show_replay_btn = true
  @show_hit_or_stay_btn = false
  @show_dealer_won = "Dealer won the round!"
  erb :game
end

