puts "kkk"
module Qt
  def self.violet
    1
  end
  
  class Color
    def initialize(color)
      super
      if color == 1
        puts "dupa"
        setRgb 93, 0, 93
      end
      puts "jajco"
    end
  end
end
