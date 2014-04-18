#Written by Thomas Upfold for smash community
#TODO:
# => do other functions 
# => addBracket not working for files other than "Brackets.tio" I don't even

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
		commandToken = args.slice!(0)
		if (commandToken == 'exit' || commandToken == 'quit') 
			menuLoop = false
		else
			Commands.send(commandToken, args)
		end
	rescue NoMethodError
		puts "#{commandToken} is not a valid command. Type 'help' for a list of commands."
	end
end