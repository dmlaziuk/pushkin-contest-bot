class Word
  attr_reader :word
  attr_reader :hash
  attr_reader :length
  attr_reader :chars_arr

  def initialize(word)
    @word = word
    @hash = word.hash
    @length = word.length
    arr = word.scan(/./)
    @chars_arr = arr.map(&:hash)
  end
end