#Written by Thomas Upfold for smash community
#TODO:
# => Find ot why winLoss isn't retaining data
# => do other functions 


require 'nokogiri'
require_relative 'commands.rb'

players = Hash.new{|hash,key| hash[key] = []}
winLoss = Hash.new({:wonAgainst => [], :lostAgainst => [] })
IDtoPlayer = {}

def assign(args)
	#Usage assign player1 player2
	#Assigns one alias to another for discrepancies across tournaments
	# => Should store these assignments so they don't need to be run each time
	puts "assign"
end
def wins(args)
	#Usage wins player1 player2 ... playerN
	#Fetches the 'wonAgainst' array for target players
	if winLoss == {}
		puts "No win/loss data recorded. Try adding a bracket before running this"
		return
	end
	puts "wins"
end
def losses(args)
	#Usage: losses player1 player2 ... playerN
	#fetches the 'lostAgainst' array for target players
	if winLoss == {}
		puts "No win/loss data recorded. Try adding a bracket before running this"
		return
	end
	puts "losses"
end
def help(args)
	puts self.methods(false)[1..-1]
end
def addBracket(args)
	#Usage addBracket filePath bracketName
	tioFile = Nokogiri::XML(open(args[0]))
	tioFile.xpath("//Players/Player").each do |node|
		IDtoPlayer[node.xpath("ID").text] = node.xpath("Nickname").text
		# Couldn't get the nokogiri node funtions working properly so i used the xpath, it sucks, i know
	end
	#gets win/loss data and converts the ID associated with the players involved and replaces
	#it with their nickname/alias i.e. someNumbers => 'AkiTheBakaQueen'
	winLoss = Hash.new({:wonAgainst => [], :lostAgainst => [] })
	tioFile.xpath("//Game").each do |node|
		if node.xpath("Name").text.downcase == args[1].to_s.downcase
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
	end
	puts "added"
end

menuLoop = true
while (menuLoop)
	begin
		args = gets.chomp.split
		commandToken = args.slice!(0)
		if (commandToken == 'exit' || commandToken == 'quit') 
			menuLoop = false
		else
			self.send(commandToken, args)
		end
	rescue NoMethodError
		puts "#{commandToken} is not a valid command. Type 'help' for a list of commands."
	end
end
puts winLoss