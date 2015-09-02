player_hand = [["S", "5"], ["H", "Q"]]

total = 0
player_hand.each do |card|
	if card[1] == 'J' || card[1] == 'Q' || card[1] == 'K' || card[1] == 'A' 
		total += 10
	else
		total += card[1].to_i
	end
end