require_relative "spec_helper"
require 'stringio'

describe Connect4 do
	
	let(:game) { Connect4.new }

	describe "#new" do
		
		it "creates a 7x6 board" do
			expect(game.board.size).to eq 6
			game.board.each do |row|
				expect(row.size).to eq 7
			end
		end

		it "creates two player objects" do
			expect(game.players.size).to eq 2
			expect(game.players).to all be_a Connect4::Player
		end

	end

	describe "#valid_input?" do

		it "accepts valid column number" do
			expect(game.valid_input?("2")).to be true
		end

		it "rejects invalid column number" do
			expect(game).to receive(:puts).with("Invalid input. Enter a column number between 1 and 7:").twice
			expect(game.valid_input?("999")).to be false
			expect(game.valid_input?("hello")).to be false
		end

		it "rejects input if column is full" do
			game.board[0][0] = "X"
			game.board[1][0] = "O"
			game.board[2][0] = "X"
			game.board[3][0] = "X"
			game.board[4][0] = "O"
			game.board[5][0] = "X"
			expect(game).to receive(:puts).with("Column 1 is full! Try again:")
			expect(game.valid_input?("1")).to be false
		end

	end

	describe "#mark_column" do
		
		it "marks next empty column space" do
			game.mark_column("X",0)
			expect(game.board[0][0]).to eq " "
			expect(game.board[1][0]).to eq " "
			expect(game.board[2][0]).to eq " "
			expect(game.board[3][0]).to eq " "
			expect(game.board[4][0]).to eq " "
			expect(game.board[5][0]).to eq "X"
			game.mark_column("O",0)
			expect(game.board[0][0]).to eq " "
			expect(game.board[1][0]).to eq " "
			expect(game.board[2][0]).to eq " "
			expect(game.board[3][0]).to eq " "
			expect(game.board[4][0]).to eq "O"
			expect(game.board[5][0]).to eq "X"
		end

		it "does not add mark to full column" do
			game.board[0][0] = "X"
			game.board[1][0] = "O"
			game.board[2][0] = "X"
			game.board[3][0] = "X"
			game.board[4][0] = "O"
			game.board[5][0] = "X"
			expect(game.col_full?(0)).to be true
			game.mark_column("O",0)
			expect(game.board[0][0]).to eq "X"
		end

	end

	describe "#game_over" do
		
		context "winner" do
			it "wins with four horizontal" do
				game.board[0] = [" "," ","X","X","X","X"," "]
				expect(game.row_winner).to be game.players[0]
			end

			it "wins with four vertical" do
				game.board[1][2],game.board[2][2],game.board[3][2],game.board[4][2] = "X","X","X","X"
				expect(game.column_winner).to be game.players[0]
			end

			it "wins with four diagonal (down)" do
				game.board[2][2],game.board[3][3],game.board[4][4],game.board[5][5] = "O","O","O","O"
				expect(game.diag_winner).to be game.players[1]
			end

			it "wins with four diagonal (up)" do
				game.board[3][0],game.board[2][1],game.board[1][2],game.board[0][3] = "O","O","O","O"
				expect(game.diag_winner).to be game.players[1]
			end
		end

		context "no winner" do
			it "is a draw" do
				game.board[0] = ["X","O","X","O","X","O","O"]
				game.board[1] = ["O","O","X","O","O","X","X"]
				game.board[2] = ["X","X","O","X","X","O","X"]
				game.board[3] = ["X","X","X","O","O","O","X"]
				game.board[4] = ["O","O","X","O","X","X","O"]
				game.board[5] = ["X","X","X","O","X","O","X"]
				expect(game.board_full?).to be true
				expect(game.winner).to be nil
				expect(game.is_draw?).to be true
			end
		end

	end


end