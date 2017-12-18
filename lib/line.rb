require_relative 'word'

class Line
  attr_reader :line_orig
  attr_reader :line
  attr_reader :line_hash
  attr_reader :words_count
  attr_reader :words_arr

  def initialize(line)
    @line_orig = line
    arr = line.scan(/[\p{Word}\-]+/) # array of words without punctuation
    @line = arr.join(' ')
    @line_hash = @line.hash
    @words_arr = arr.map { |word| Word.new(word) }
    @words_count = arr.size
  end
end
