require_relative 'verse'

class Pushkin
  def initialize()
    @verses = []          # all verses
    @hash2line = {}       # line hash => "line"
    @hash2word = {}       # word hash => "word"
    @hash2title = {}      # line hash => "title"
    @wc2lineh = {}        # words count => [line hash]
    @next_line = {}       # line hash => next line hash
    @hash2words_arr = {}  # line hash => [word hash]
    @hash2chars_arr = {}  # line hash => [char hash]
    @cc2lineh = {}        # chars count => [line hash]
  end

  def add(title, text)
    @verses << Verse.new(title, text)
  end

  def run_level1(question)
    # remove punctuation
    line = question.scan(/[\p{Word}\-]+/).join(' ')
    puts "    Line:#{line}"
    @hash2title[line.hash]
  end

  def run_level2(question)
    # remove punctuation
    words = question.scan(/[\p{Word}\-]+/)
    words_count = words.size
    line = words.join(' ')
    puts "    Line:#{line}"
    query = Regexp.new(line.gsub('WORD','([\p{Word}\-]+)'))
    @wc2lineh[words_count].each do |line_hash|
      query.match(@hash2line[line_hash]) do |word|
        return word[1]
      end
    end
    'нет'
  end

  def run_level3(question)
    lines = question.split("\n")
    # remove punctuation
    lines.map! { |line| line.scan(/[\p{Word}\-]+/).join(' ') }
    lines.each { |line| puts "    Line:#{line}" }
    words_count = lines[0].split.size
    query1 = Regexp.new(lines[0].gsub('WORD','([\p{Word}\-]+)'))
    query2 = Regexp.new(lines[1].gsub('WORD','([\p{Word}\-]+)'))
    @wc2lineh[words_count].each do |lh|
      line1 = @hash2line[lh]
      query1.match(line1) do |word1|
        line2 = @hash2line[@next_line[line1.hash]]
        query2.match(line2) do |word2|
          return "#{word1[1]},#{word2[1]}"
        end
      end
    end
    'нет'
  end

  def run_level4(question)
    lines = question.split("\n")
    # remove punctuation
    lines.map! { |line| line.scan(/[\p{Word}\-]+/).join(' ') }
    lines.each { |line| puts "    Line:#{line}" }
    words_count = lines[0].split.size
    query1 = Regexp.new(lines[0].gsub('WORD','([\p{Word}\-]+)'))
    query2 = Regexp.new(lines[1].gsub('WORD','([\p{Word}\-]+)'))
    query3 = Regexp.new(lines[2].gsub('WORD','([\p{Word}\-]+)'))
    @wc2lineh[words_count].each do |lh|
      line1 = @hash2line[lh]
      query1.match(line1) do |ans1|
        line2 = @hash2line[@next_line[line1.hash]]
        query2.match(line2) do |ans2|
          line3 = @hash2line[@next_line[line2.hash]]
          query3.match(line3) do |ans3|
            return "#{ans1[1]},#{ans2[1]},#{ans3[1]}"
          end
        end
      end
    end
    'нет'
  end

  def run_level5(question)
    # remove punctuation
    words = question.scan(/[\p{Word}\-]+/)
    words_arr = words.map { |word| word.hash }
    words_count = words.size
    line = words.join(' ')
    puts "    Line:#{line}"
    @wc2lineh[words_count].each do |line_hash|
      diff = @hash2words_arr[line_hash] - words_arr
      if diff.size == 1
        word1 = @hash2word[diff.first]
        word2 = @hash2word[(words_arr - @hash2words_arr[line_hash]).first]
        return "#{word1},#{word2}"
      end
    end
    'нет'
  end

  def run_level6(question)
    words = question.scan(/[\p{Word}\-]+/)
    words_count = words.size
    chars_arr = words.map { |word| word.scan(/./).map(&:hash) }
    chars_arr.flatten!
    @wc2lineh[words_count].each do |line_hash|
      diff1 = @hash2chars_arr[line_hash] - chars_arr
      diff2 = chars_arr - @hash2chars_arr[line_hash]
      return @hash2line[line_hash] if diff1.empty? && diff2.empty?
    end
    'нет'
  end

  def run_level7(question)
    line = question.scan(/[\p{Word}\-]+/).join
    puts "    Line:#{line}"
    chars_arr = line.scan(/./).map(&:hash)
    chars_count = chars_arr.size
    @cc2lineh[chars_count].each do |line_hash|
      diff1 = chars_arr - @hash2chars_arr[line_hash]
      diff2 = @hash2chars_arr[line_hash] - chars_arr
      return @hash2line[line_hash] if diff1.empty? && diff2.empty?
    end
    'нет'
  end

  def run_level8(question)
    line = question.scan(/[\p{Word}\-]+/).join
    puts "    Line:#{line}"
    chars_arr = line.scan(/./).map(&:hash)
    chars_count = chars_arr.size
    @cc2lineh[chars_count].each do |line_hash|
      diff1 = chars_arr - @hash2chars_arr[line_hash]
      diff2 = @hash2chars_arr[line_hash] - chars_arr
      if diff1.size <= 1 && diff2.size <=1
        return @hash2line[line_hash]
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
    @verses.each do |verse|
      verse.lines_arr.each do |line|
        # line hash => "line"
        @hash2line[line.line_hash] = line.line
        # line hash => "title"
        @hash2title[line.line_hash] = verse.title
        # words count => [line_hash]
        @wc2lineh[line.words_count] ||= []
        @wc2lineh[line.words_count] << line.line_hash
        @next_line[prev] = line.line_hash
        prev = line.line_hash
        # line hash => [word_hash]
        @hash2words_arr[line.line_hash] = line.words_arr.map { |word| word.word_hash }
        @hash2chars_arr[line.line_hash] ||= []
        chars_count = 0
        line.words_arr.each do |word|
          @hash2word[word.word_hash] = word.word
          @hash2chars_arr[line.line_hash] << word.chars_hash_arr
          chars_count += word.word_length
        end
        @hash2chars_arr[line.line_hash].flatten!
        @cc2lineh[chars_count] ||= []
        @cc2lineh[chars_count] << line.line_hash
      end
    end
    @next_line[prev] = @verses[0].lines_arr[0].line_hash
  end
end
