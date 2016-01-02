class Connect4

	BOARD_WIDTH = 7
	BOARD_HEIGHT = 6

	attr_reader :players, :board

	def initialize(player1 = "Player 1", player2 = "Player 2")
		clean_board
		@players = [Player.new(player1,"X"), Player.new(player2,"O")]
		#play
	end

	def clean_board
		@board = [
			[" "," "," "," "," "," "," "],
			[" "," "," "," "," "," "," "],
			[" "," "," "," "," "," "," "],
			[" "," "," "," "," "," "," "],
			[" "," "," "," "," "," "," "],
			[" "," "," "," "," "," "," "]
		]
	end

	#print a table of cells
	def print_board
		@board.each_with_index do |row,i|
			puts_hr
			print "|"
			row.each_with_index do |cell|
				print " #{cell} |"
			end
			print "\n"
		end
		puts_hr
		print "  1"
		2.upto(@board[0].size) do |num|
			print "   #{num}"
		end
		print "\n"
	end

	#print a horizontal rule of board width
	def puts_hr
		print "|"
		(@board[0].size-1).times do
			print "----"
		end
		print "---"
		print "|\n"
	end

	#row winning condition
	def row_winner
		win = nil
		@board.each do |row|
			@players.each do |player|
				BOARD_WIDTH.times do |i|
					if i + 3 < BOARD_WIDTH
						win = player if row[i..i+3].all? { |m| m == player.mark }
					end
					break if win
				end
			end
			break if win 
		end
		win
	end

	#column winning condition
	def column_winner
		win = nil
		@board.size.times do |col|
			column = []
			@board.size.times do |row|
				column << @board[row][col].to_s
			end
			@players.each do |player|
				BOARD_HEIGHT.times do |i|
					if i + 3 < BOARD_HEIGHT
						win = player if column[i..i+3].all? { |m| m == player.mark }
					end
					break if win
				end
			end
			break if win
		end
		win
	end

	#diagonal winning condition
	def diag_winner
		win = nil
		diags = get_diagonals(@board).select { |d| d.size >= 4 }
		diags.each do |d|
			d.size.times do |i|
				if i + 3 < d.size
					@players.each do |player|
						win = player if d[i..i+3].all? { |m| m == player.mark }
						break if win
					end
				end
				break if win
			end
			break if win
		end
		win
	end

	def get_diagonals(matrix)
		diagonals = []
		#down slope diagonals
		(matrix.size-1).times do |shift|
			diag_upper = []
			diag_lower = []
			(matrix[0].size-1).times do |i|
				diag_upper << matrix[i][i+shift] if i+shift < matrix[0].size
				diag_lower << matrix[i+1+shift][i] if i+1+shift < matrix.size
			end
			diagonals << diag_upper
			diagonals << diag_lower
		end
		#up slope diagonals
		(matrix.size-1).downto(0) do |i|
			diag_lower = []
			(matrix[0].size-1).times do |shift|
				diag_lower << matrix[i-shift][shift] if i-shift > -1
			end
			diagonals << diag_lower
		end
		(matrix.size-1).times do |i|
			diag_upper = []
			(matrix[0].size-1).times do |shift|
				diag_upper << matrix[matrix.size-shift-1][shift+i+1] if matrix.size-shift-1 > -1 && shift+i+1 < matrix[0].size
			end
			diagonals << diag_upper
		end
		diagonals
	end

	#check possible winning conditions
	def winner
		row_winner || column_winner || diag_winner
	end

	#is the board full but no winner?
	def is_draw?
		board_full? && !winner
	end

	#check if board is filled
	def board_full?
		@board.none? { |row| row.include?(" ") }
	end

	#check if a column is full
	def col_full?(col)
		column = []
		@board.size.times do |row|
			column << @board[row][col] 
		end
		column.none? { |m| m == " " }
	end

	#game ends if the board is full or if someone wins
	def game_over?
		board_full? || winner
	end

	#validate user input
	def valid_input?(input)
		if ( input.to_i > 0 && input.to_i <= BOARD_WIDTH )
			if col_full?(input.to_i-1)
				puts "Column #{input} is full! Try again:"
				return false
			else
				return true
			end
		else
			puts "Invalid input. Enter a column number between 1 and 7:"
			return false
		end
	end

	#add player mark to next empty column space
	def mark_column(mark,col)
		(@board.size-1).downto(0) do |row|
			if ( @board[row][col] == " " )
				@board[row][col] = mark
				break
			end
		end
	end

	#main gameplay loop
	def play
		until game_over? do
			players.each do |player|

				break if game_over?
				print_board

				puts "#{player.name}'s turn:"
				move = gets.chomp

				until valid_input?(move) do
					move = gets.chomp
				end

				mark_column(player.mark, move.to_i-1)

			end
		end
		print_board
		puts is_draw? ? "It's a draw!" : "The winner is: #{winner.name}!"
		play_again_check
	end

	#option to swap players and play again
	def play_again_check
		puts "Would you like to play again?"
		input = gets.chomp.downcase
		if input != "no" && input != "n"
			if input == "yes" || input == "y"
				@players.reverse!
				clean_board
				play
			else
				puts "Respond yes or no"
				play_again_check
			end
		end
	end

	#player object
	class Player
		attr_accessor :name
		attr_reader :mark
		def initialize(name,mark)
			@name = name
			@mark = mark
		end
	end

end