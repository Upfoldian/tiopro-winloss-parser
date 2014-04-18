class Commands
	def self.processCommand(cmd, *args)
		self.send(cmd, args)
	rescue NoMethodError
		puts "#{cmd} is not a valid command. Type 'help' for a list of commands."
	end

	def self.assign(*args)
		puts "assign"
	end
	def self.wins(*args)
		puts "wins"
	end
	def self.losses(*args)
		puts "losses"
	end
	def self.help(*args)
		puts self.methods(false)[1..-1]
	end
end

menuLoop = true
while (menuLoop)
	args = gets.chomp.split
	commandToken = args.slice!(0)
	Commands.processCommand(commandToken, args)
end