require_relative 'verse'

class Pushkin
  def initialize()
    @vol = []
    @line2title = Hash.new
    @lines_hash = Hash.new
    @words_hash = Hash.new
    @chars_hash = Hash.new
  end

  def add(title, text)
    @vol << Verse.new(title, text)
  end

  def run
    init_hash
    print_hash
  end

  def to_s
    str = ''
    @vol.each do |v|
      str << "#{v.title}\n\n"
      v.lines_arr.each do |l|
        str << "#{l.line}\n"
      end
      str << "\n\n"
    end
    str
  end

  def init_hash
    @vol.each do |v|
      v.lines_arr.each do |l|
        @line2title[l.hash] = v.title
        @lines_hash[l.hash] = l.line
        l.words_arr.each do |w|
          @words_hash[w.hash] = w.word
          w.chars_arr.each_with_index do |c, i|
            @chars_hash[c] = w.word[i]
          end
        end
      end
    end
  end

  def print_hash
    puts 'Line2Title:'
    puts @line2title
    puts 'Lines:'
    puts @lines_hash
    puts 'Words:'
    puts @words_hash
    puts 'Chars:'
    puts @chars_hash
  end
end
