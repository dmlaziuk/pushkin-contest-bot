require_relative 'verse'

class Pushkin
  def initialize()
    @verses = []
    @lines_hash = {}
    @words_hash = {}
    @chars_hash = {}
    @line2title = {}
    @wc2lines = {}
    @next_line = {}
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

  def run_level3(q_arr)
    text = q_arr[0]
    arr = text.split
    size = arr.size
    q1 = text.gsub('WORD','([\p{Word}\-]+)')
    q2 = q_arr[1].gsub('WORD','([\p{Word}\-]+)')
    query1 = Regexp.new(q1)
    query2 = Regexp.new(q2)
    @wc2lines[size].each do |lh|
      line1 = @lines_hash[lh]
      query1.match(line1) do |ans1|
        line2 = @lines_hash[@next_line[line1.hash]]
        query2.match(line2) do |ans2|
          return "#{ans1[1]},#{ans2[1]}"
        end
      end
    end
    'нет'
  end

  def run_level4(q_arr)
    text = q_arr[0]
    arr = text.split
    size = arr.size
    q1 = text.gsub('WORD','([\p{Word}\-]+)')
    q2 = q_arr[1].gsub('WORD','([\p{Word}\-]+)')
    q3 = q_arr[2].gsub('WORD','([\p{Word}\-]+)')
    query1 = Regexp.new(q1)
    query2 = Regexp.new(q2)
    query3 = Regexp.new(q3)
    @wc2lines[size].each do |lh|
      line1 = @lines_hash[lh]
      query1.match(line1) do |ans1|
        line2 = @lines_hash[@next_line[line1.hash]]
        query2.match(line2) do |ans2|
          line3 = @lines_hash[@next_line[line2.hash]]
          query3.match(line3) do |ans3|
            return "#{ans1[1]},#{ans2[1]},#{ans3[1]}"
          end
        end
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
    prev = @verses[-1].lines_arr[-1].line_hash
    @verses.each do |v|
      v.lines_arr.each do |l|
        @lines_hash[l.line_hash] = l.line
        @line2title[l.line_hash] = v.title
        @wc2lines[l.words_count] ||= []
        @wc2lines[l.words_count] << l.line_hash
        @next_line[prev] = l.line_hash
        prev = l.line_hash
        l.words_arr.each do |w|
          @words_hash[w.word_hash] = w.word
          w.chars_hash_arr.each_with_index do |c, i|
            @chars_hash[c] = w.word[i]
          end
        end
      end
    end
    @next_line[prev] = @verses[0].lines_arr[0].line_hash
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
