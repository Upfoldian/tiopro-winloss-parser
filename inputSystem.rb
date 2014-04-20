#Written by Thomas Upfold for smash community
#TODO:
# => do the alias functionality

require 'nokogiri'
require_relative 'commands.rb'
#These are made global vars because I wanted to offload the commands to another file
$players = Hash.new{|hash,key| hash[key] = []}
$winLoss = Hash.new({:wonAgainst => [], :lostAgainst => [] })
$IDtoPlayer = {}

while (true)
	begin
		args = gets.chomp.split
		commandToken = args[0]
		if (commandToken.downcase == 'exit' || commandToken.downcase == 'quit') 
			puts "seeya"
			break;
		end
		args.shift
		args = args.join(' ')[1..-2].split(/" "/)
		puts "Command Token: #{commandToken}, Args: #{args.to_s}"
		Commands.send(commandToken, args)
	rescue NoMethodError
		puts "#{commandToken} is not a valid command. Type 'help' for a list of commands."
	end
end