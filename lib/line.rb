require_relative 'word'

class Line
  attr_reader :line
  attr_reader :hash
  attr_reader :words_count
  attr_reader :words_arr

  def initialize(line)
    @line = line
    @hash = line.hash
    arr = line.scan(/[\p{Word}\-]+/) # array of words without punctuation
    @words_arr = arr.map { |word| Word.new(word) }
    @words_count = arr.size
  end
end
