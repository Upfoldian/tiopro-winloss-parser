require 'nokogiri'

tioFile = Nokogiri::XML(open('Brackets.tio'))


#sets up the id to player nickname hash
#Written by Thomas Upfold for the smash community

IDtoPlayer = {}
tioFile.xpath("//Players/Player").each do |node|
	IDtoPlayer[node.xpath("ID").text] = node.xpath("Nickname").text
	# Couldn't get the nokogiri node funtions working properly so i used the xpath, it sucks, i know
end

#gets win/loss data and converts the ID associated with the players involved and replaces
#it with their nickname/alias i.e. someNumbers => 'AkiTheBakaQueen'
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

			winLoss[winner][:wonAgainst].push(loser)
			winLoss[loser][:lostAgainst].push(winner)
		end
	end
	#Outputs win/loss data in sorted order, it indents with tabs, deal with it
	file = File.open("RoS3wl.txt", "w")
	asdf = winLoss.sort_by {|key, val| val[:wonAgainst].length}.reverse
	asdf = Hash[asdf.map {|key, value| [key, value]}]
	asdf.each_key do |player| 
		file.puts "Player " + player + " match record"
		file.puts "\tWon against: " + winLoss[player][:wonAgainst].to_s
		file.puts "\tLost against: " + winLoss[player][:lostAgainst].to_s
	end
end