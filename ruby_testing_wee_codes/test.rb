player_hand = [["S", "5"], ["H", "A"], ["H", "A"]]

total = []
player_hand.each do |card|
	if card[1] == 'J' || card[1] == 'Q' || card[1] == 'K' 
		total << 10
	elsif card[1] == 'A' 
		total << 11
	else
		total << card[1].to_i
	end
end

while total.inject(:+) > 21 && total.max == 11
	total.pop
	total << 1
	total.sort!
end

p total
puts total.inject(:+)