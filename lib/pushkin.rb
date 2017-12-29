require 'logger'
require_relative 'verse'

class Pushkin
  def initialize
    @verses = []          # all verses
    @hash2line = {}       # line hash => "line"
    @hash2line_orig = {}  # line hash => "line"
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
    @hash2title[line.hash]
  end

  def run_level2(question)
    # remove punctuation
    words = question.scan(/[\p{Word}\-]+/)
    words_count = words.size
    line = words.join(' ')
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
    return run_level2(question) if lines.size == 1
    # remove punctuation
    lines.map! { |line| line.scan(/[\p{Word}\-]+/).join(' ') }
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
    return run_level3(question) if lines.size == 2
    # remove punctuation
    lines.map! { |line| line.scan(/[\p{Word}\-]+/).join(' ') }
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
    chars_arr = question.scan(/./).map(&:hash)
    chars_count = chars_arr.size
    @cc2lineh[chars_count].each do |line_hash|
      diff1 = @hash2chars_arr[line_hash] - chars_arr
      diff2 = chars_arr - @hash2chars_arr[line_hash]
      return @hash2line_orig[line_hash] if diff1.empty? && diff2.empty?
    end
    'нет'
  end

  def run_level7(question)
    run_level6(question)
  end

  def run_level8(question)
    chars_arr = question.scan(/./).map(&:hash)
    chars_count = chars_arr.size
    @cc2lineh[chars_count].each do |line_hash|
      orig_arr = @hash2line_orig[line_hash].scan(/[\p{^Punct}\-]/).map(&:hash)
      arr = Array.new(orig_arr)
      diff1 = chars_arr.map { |i| (ind = arr.index(i)) ? (arr[ind] = nil) : i }
      diff1.compact!
      next if diff1.size > 1
      diff2 = orig_arr.map { |i| (ind = chars_arr.index(i)) ? (chars_arr[ind] = nil) : i }
      diff2.compact!
      next if diff2.size > 1
      return @hash2line_orig[line_hash]
    end
    'нет'
  end

  def run_level8_1(question)
    chars_arr = question.scan(/[\p{L}\-]/).map(&:hash)
    chars_count = chars_arr.size
    @cc2lineh[chars_count].each do |line_hash|
      diff1 = chars_arr - @hash2chars_arr[line_hash]
      diff2 = @hash2chars_arr[line_hash] - chars_arr
      return @hash2line_orig[line_hash] if diff1.size <= 1 && diff2.size <= 1
    end
    'нет'
  end

  def run_level8_2(question)
    chars_arr = question.scan(/[\p{L}\-]/).map(&:hash)
    chars_count = chars_arr.size
    @cc2lineh[chars_count].each do |line_hash|
      arr1 = Array.new(chars_arr)
      arr2 = Array.new(@hash2chars_arr[line_hash])
      arr1.map! do |i|
        ind = arr2.index(i)
        if ind
          arr2[ind] = nil
          nil
        else
          i
        end
      end
      diff1 = arr1.compact
      next if diff1.size > 1
      arr1 = Array.new(chars_arr)
      arr2 = Array.new(@hash2chars_arr[line_hash])
      arr2.map! do |i|
        ind = arr1.index(i)
        if ind
          arr1[ind] = nil
          nil
        else
          i
        end
      end
      diff2 = arr2.compact
      return @hash2line_orig[line_hash] if diff1.size <= 1 && diff2.size <= 1
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
        @hash2line_orig[line.line_hash] = line.line_orig
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
        line.words_arr.each do |wrd|
          @hash2word[wrd.word_hash] = wrd.word
        end
        @hash2chars_arr[line.line_hash] = line.line_orig.scan(/[\p{^Punct}\-]/).map(&:hash)
        chars_count = @hash2chars_arr[line.line_hash].size
        @cc2lineh[chars_count] ||= []
        @cc2lineh[chars_count] << line.line_hash
      end
    end
    @next_line[prev] = @verses[0].lines_arr[0].line_hash
  end
end
