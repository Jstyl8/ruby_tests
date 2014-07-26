
###################################################################
# Ruby Script to check if algorithm works in any of 32 posible states
# The riddle consist on a line of 5 people wearing a t-shirt with a white or black dot on the back.
# A killer with a gun asks each of them in order what's the dot's color on his t-shirt.
# If the one he is asking gets it right, lives, if doesn't he dies.
# Objective is trying to get a way always at least 4 of them survive
# Algorithm
#      | f(x0) = c(1,x0)
# f(x)=|
#      | f(xi) = c(1,xi) XOR f(x0) |-| 0 < xi <= 5
#
# C(1,xi): says if number of 1's is par or odd without taking into account xi or x0
###################################################################
class NotPerfectAlgorithm < RuntimeError
end

module RiddleRow5
    @row, @alives, @answers = [], [], []
    
    def self.run1 row
        init row
        fx
        die
        showResults
    end

    def self.runall
        (0..31).each { |n| run1 ("%05b" % n).scan(/./) }
        puts "All cases are completed, your algorithm is perfect, well done!"
    end

    private

    def self.init row
        @row = row
        @alives.clear
        @answers.clear
    end

    def self.fx 
        @answers.push fx0
        ronly4.each { |xi| @answers << fxi(xi) }
    end

    # Kill person if answered wrong
    def self.die
        @row.each_with_index { |xi, i| xi == @answers[i] ? @alives << "V" : @alives << "M" }
    end

    def self.showResults
        nAlives = @alives.count("V")
        puts %[Row init:\t#{@row}\nAnswers:\t#{@answers}\nLeft alives:\t#{@alives} - #{nAlives}/5]
        raise  NotPerfectAlgorithm.new "Solution did not work on this case" unless nAlives >=4
        puts "--------------------------------------------"
    end

    # What x0 sees
    def self.fx0
        c1 @row.first
    end

    # What xi sees thinking on what x0 saw
    def self.fxi xi
        n1 = c1 xi
        (n1 ^ @answers.first.to_i).to_s
    end

    def self.c1 xi
        block = lambda { |x| x.object_id != xi.object_id && x=="1" } 
        ronly4.count(&block) % 2
    end

    def self.ronly4
        @row[1 , @row.size]
    end
end

RiddleRow5.runall
