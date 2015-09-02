def calculate_total(user_hand, user_total)
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
end

# FAILING HERE WHEN IMPLEMENTING DEALER_TO_21
def dealer_to_21
	begin
		provide_card(:dealer_hand)
		session[:dealer_total] = calculate_total(session[:dealer_hand], session[:dealer_total])
	end until session[:dealer_total] >= 17
	session[:dealer_total]
end

post '/hit_stay' do
	# THIS UNCOMMENTED PART WORKS but I want to avoid doing it like that
	#session[:player_total] = calculate_total(session[:player_hand], session[:player_total])
	#session[:dealer_total] = calculate_total(session[:dealer_hand], session[:dealer_total])

	if params['hit']
		
	elsif params['stay']
		dealer_to_21(session[:player_total], session[:dealer_total])
		erb :stay
	end
end
