# INTENDATION!!!!!
require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

get '/' do 	
	@@variable = 0
	redirect '/user_name'
end

get '/user_name' do

	@@variable += 1
	erb :user_name
end

post '/user_name' do 

	@@variable += 1
	if !params['user_name'].empty?
		session[:user_name] = params['user_name']
		erb :bet_amount
	else
		redirect '/'
	end
end

post '/bet_amount' do
	puts @@variable 
	if params['bet_amount'].empty? || params['bet_amount'].to_i > 500
		erb :bet_amount
	else
		session[:bet_amount] = params['bet_amount']
		redirect '/game'
	end
end

def create_deck
	suits = %w[H D C S]
	cards = %w[2 3 4 5 6 7 8 9 10 J Q K A]
	deck = suits.product(cards)
	session[:deck] = deck.shuffle!
end

def provide_card(user_hand)
	session[user_hand] << session[:deck].pop
end

def create_hands
	session[:dealer_hand] = []
	session[:player_hand] = []
end

def first_hand
	3.times do 
		provide_card(:dealer_hand)
		provide_card(:player_hand)
	end
end

get '/game' do
	create_deck
	create_hands
	first_hand	
	erb :game
end

def calculate_total(user_hand, user_total)
	user_total = []
	user_hand.each do |card|
		if card[1] == 'J' || card[1] == 'Q' || card[1] == 'K' 
			user_total << 10
		elsif card[1] == 'A' 
			user_total << 11
		else
			user_total << card[1].to_i
		end
	end
	while user_total.inject(:+) > 21 && user_total.max == 11
		user_total.sort!
		user_total.pop
		user_total << 1
		user_total.sort!  # DELETEABLE?
	end
	user_total
	# binding.pry
end

# FAILING HERE WHEN IMPLEMENTING DEALER_TO_21
# WORKING BOTH PLAYERS UNTIL HERE
def dealer_to_21
	# begin
	# 	provide_card(:dealer_hand)
	# 	session[:dealer_total] = calculate_total(session[:dealer_hand], session[:dealer_total])
	# end until session[:dealer_total] >= 17
	# session[:dealer_total]
end

post '/hit_stay' do
	session[:player_total] = calculate_total(session[:player_hand], session[:player_total])
	session[:dealer_total] = calculate_total(session[:dealer_hand], session[:dealer_total])

	if params['hit']
		
	elsif params['stay']
		#dealer_to_21
		erb :stay
	end
end







