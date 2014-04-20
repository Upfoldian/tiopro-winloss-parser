class Commands
	def self.assign(args)
		#Usage assign "player1" "player2"
		#Assigns one alias to another for discrepancies across tournaments
		# => Should store these assignments so they don't need to be run each time
		#First add player2 stuff to player1
		$winLoss[args[0]][:wonAgainst] += $winLoss[args[1]][:wonAgainst]
		$winLoss[args[0]][:lostAgainst] += $winLoss[args[1]][:lostAgainst]

		#Then change all player2 entries to player1
		$winLoss.each_key do |key|
			$winLoss[key][:wonAgainst].map!{|x| x == args[1] ? args[0] : x}
			$winLoss[key][:lostAgainst].map!{|x| x == args[1] ? args[0] : x}
		end
	end
	def self.wins(args)
		#Usage wins "player1" "player2" ... "playerN"
		#Fetches the 'wonAgainst' array for target players
		if $winLoss.size == 0
			puts "Yo, there isn't any data yet. Add a bracket goofhead"
			return
		end
		result = []
		args.each do |player|
			puts "#{player} has won against #{$winLoss[player][:wonAgainst]}"
		end
	end
	def self.losses(args)
		#Usage: losses "player1" "player2" ... "playerN"
		#fetches the 'lostAgainst' array for target players
		if $winLoss.size == 0
			puts "Yo, there isn't any data yet. Add a bracket goofhead"
			return
		end
		result = []
		args.each do |player|
			puts "#{player} has lost against #{$winLoss[player][:lostAgainst]}"
		end
	end
	def self.help(args)
		puts self.methods(false)[1..-1]
	end
	def self.addBracket(args)
		#Usage addBracket "filePath" "bracketName"
		tioFile = Nokogiri::XML(open(args[0]))
		tioFile.xpath("//Players/Player").each do |node|
			$IDtoPlayer[node.xpath("ID").text] = node.xpath("Nickname").text
			# Couldn't get the nokogiri node funtions working properly so i used the xpath, it sucks, i know
		end
		#gets win/loss data and converts the ID associated with the players involved and replaces
		#it with their nickname/alias i.e. someNumbers => 'AkiTheBakaQueen'
		tioFile.xpath("//Game").each do |node|
			if node.xpath("Name").text.downcase == args[1].to_s.downcase
				node.xpath("Entrants/Entrant/PlayerID").each do |entrant|
					if !$winLoss.has_key?($IDtoPlayer[entrant.text])
						puts "Player '#{$IDtoPlayer[entrant.text]}' was added"
						$winLoss[$IDtoPlayer[entrant.text]] = {:wonAgainst => [], :lostAgainst => [] }
					end
				end
				node.xpath("Bracket/Matches/Match").each do |match|
					player1 = $IDtoPlayer[match.xpath("Player1").text]
					player2 = $IDtoPlayer[match.xpath("Player2").text]
					winner = $IDtoPlayer[match.xpath("Winner").text]
					loser = (player1 == winner ? player2 : player1)

					$winLoss[winner][:wonAgainst].push(loser)
					$winLoss[loser][:lostAgainst].push(winner)
				end
			end
		end
	end
end