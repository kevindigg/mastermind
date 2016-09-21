
class Player
    attr_reader :name

    def initialize(name)
        @name = name
    end
end

class Game
    MAX_GUESS = 12
    attr_accessor :p1, :p2, :board, :p_guesser

    def initialize(p1="human", p2="computer")
        @guesses = 0
        @p1 = Human.new(p1)
        @p2 = Computer.new(p2)
        @board = Board.new()

        @p_guesser = get_player()
    end

    def play
        puts "Hello, #{p_guesser.name}."
        until @guesses == 12
            puts "The code is #{board.code}"
            puts "You have #{MAX_GUESS-@guesses} guesses left."
            print "Enter your guess: "
            input = gets.chomp.split("")[0..3].map { |digit| digit.to_i }
            return "That's right. You win!" if input == board.code

            place,value = board.eval_guess(input)
            puts "\n================="
            puts "You got #{place} in the right place and #{value} of the right value."

            @guesses += 1
        end

        return "\n=================\nYou ran out of guesses. The code was #{board.code}"
    end

    private
    def get_player
       if @p1.class == Human
            puts "Do you want to provide the code? (y/n)"
            input = gets.chomp
            case input.downcase
            when "y"
                print "Enter 4 digit code (no spaces): "
                code = gets.chomp.split("")[0..3].map { |digit| digit.to_i }
                board.code = code
                return @p2
            when "n"
                return @p1
            end
        end
    end

end

class Board
    attr_accessor :code

    def initialize(code = nil)

        @code = code ? code : Array.new(4) { |index| (rand(5)+1)}
    end

    def eval_guess(guess)   
        right_place,right_value = 0,0

        #check for 100% match

        #guess.each_with_index { |item,index| right_place += 1 if code[index]==item }
        #right place count
        pairs = code.zip(guess)
        pairs.delete_if {|x| x[0] == x[1]}
        right_place = code.count - pairs.count

        #right value count
        c,g = pairs.transpose
        #delete guessed elements from what's left of code
        g.each {|i| c.delete_at(c.index(i)) if c.index(i) }
        #how many unmatched pairs were left, minus how many unmatched values in code
        right_value = pairs.count-c.count

        return right_place, right_value
    end
end

class Human < Player
end

class Computer < Player
end

g = Game.new()
puts g.play