#Written by Thomas Upfold for smash community
#TODO:
# => do the alias functionality

require 'nokogiri'
require_relative 'commands.rb'
#These are made global vars because I wanted to offload the commands to another file
$players = Hash.new{|hash,key| hash[key] = []}
$winLoss = Hash.new({:wonAgainst => [], :lostAgainst => [] })
$IDtoPlayer = {}

menuLoop = true
while (menuLoop)
	begin
		args = gets.chomp.split
		commandToken = args[0]
		args.shift
		args = args.join(' ')[1..-2].split(/" "/)
		if (commandToken == 'exit' || commandToken == 'quit') 
			menuLoop = false
		else
			Commands.send(commandToken, args)
		end
	rescue NoMethodError
		puts "#{commandToken} is not a valid command. Type 'help' for a list of commands."
	end
end