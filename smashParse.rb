require 'nokogiri'

tioFile = Nokogiri::XML(open('brackets.tio'))


#sets up the id to player nickname hash
IDtoPlayer = {}
tioFile.xpath("//Players/Player").each do |node|
	#puts node.xpath("Nickname").text
	#puts node.xpath("ID").text
	#puts "======"
	IDtoPlayer[node.xpath("ID").text] = node.xpath("Nickname").text
	# Couldn't get the nokogiri node funtions working properly so i used the xpath, it sucks, i know
end

#gets win loss data, stores it in hash where ID => { wonAgainst => [], lostAgainst => [] }
winLoss = Hash.new({:wonAgainst => [], :lostAgainst => [] })
tioFile.xpath("//Game").each do |node|
	if node.xpath("Name").text == "Melee"
		puts node.xpath("Entrants/PlayerID").text
		node.xpath("Entrants/Entrant/PlayerID").each do |entrant|
			winLoss[IDtoPlayer[entrant.text]] = {:wonAgainst => [], :lostAgainst => [] }
		end
		node.xpath("Bracket/Matches/Match").each do |match|
			player1 = IDtoPlayer[match.xpath("Player1").text]
			player2 = IDtoPlayer[match.xpath("Player2").text]
			winner = IDtoPlayer[match.xpath("Winner").text]
			loser = (player1 == winner ? player2 : player1)
			puts "Winner: " + IDtoPlayer[winner].to_s + " Loser: " + IDtoPlayer[loser].to_s

			winLoss[winner][:wonAgainst].push(loser)
			winLoss[loser][:lostAgainst].push(winner)
		end
	end
	winLoss.each_key do |player| 
		puts "Player " + player + " match record"
		puts "\tWon against: " + winLoss[player][:wonAgainst].to_s
		puts "\tLost against: " + winLoss[player][:lostAgainst].to_s
	end
end