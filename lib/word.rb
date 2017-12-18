class Word
  attr_reader :word
  attr_reader :word_hash
  attr_reader :length
  attr_reader :chars_hash_arr

  def initialize(word)
    @word = word
    @word_hash = word.hash
    @length = word.length
    @chars_hash_arr = word.scan(/./).map(&:hash)
  end
end