require_relative 'verse'

class Pushkin
  attr_reader :verses
  attr_reader :lines_hash
  attr_reader :words_hash
  attr_reader :chars_hash
  attr_reader :line2title
  attr_reader :wc2lines

  def initialize()
    @verses = []
    @lines_hash = {}
    @words_hash = {}
    @chars_hash = {}
    @line2title = {}
    @wc2lines = {}
  end

  def add(title, text)
    @verses << Verse.new(title, text)
  end

  def run_level1(text)
    @line2title[text.hash]
  end

  def run_level2(text)
    arr = text.split
    size = arr.size
    q = text.gsub('WORD','([\p{Word}\-]+)')
    query = Regexp.new(q)
    @wc2lines[size].each do |lh|
      line = @lines_hash[lh]
      query.match(line) do |word|
        return word[1]
      end
    end
    'нет'
  end

  def to_s
    str = ''
    @verses.each do |v|
      str << "#{v.title}\n\n"
      v.lines_arr.each do |l|
        str << "#{l.line}\n"
      end
      str << "\n\n"
    end
    str
  end

  def init_hash
    @verses.each do |v|
      v.lines_arr.each do |l|
        @lines_hash[l.line_hash] = l.line
        @line2title[l.line_hash] = v.title
        @wc2lines[l.words_count] ||= []
        @wc2lines[l.words_count] << l.line_hash 
        l.words_arr.each do |w|
          @words_hash[w.word_hash] = w.word
          w.chars_hash_arr.each_with_index do |c, i|
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
