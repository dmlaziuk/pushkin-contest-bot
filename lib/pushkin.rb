require_relative 'verse'

class Pushkin
  def initialize
    @verses = []          # all verses
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
    line = question.scan(/[\p{Word}\-]+/).join(' ')
    @hash2title[line.hash]
  end

  def run_level2(question)
    line = question.sub('%WORD%', 'WORD')
    words_count = line.scan(/[\p{Word}\-]+/).size
    query = Regexp.new(line.sub('WORD','([\p{Word}]+)'))
    @wc2lineh[words_count].each do |line_hash|
      query.match(@hash2line_orig[line_hash]) do |word|
        return word[1]
      end
    end
    'нет'
  end

  def run_level3(question)
    lines = question.split("\n")
    return run_level2(question) if lines.size == 1
    lines.map! { |line| line.sub('%WORD%', 'WORD') }
    words_count = lines.first.scan(/[\p{Word}\-]+/).size
    query = lines.map { |line| Regexp.new(line.sub('WORD','([\p{Word}]+)')) }
    @wc2lineh[words_count].each do |lh|
      query[0].match(@hash2line_orig[lh]) do |word1|
        query[1].match(@hash2line_orig[@next_line[lh]]) do |word2|
          return "#{word1[1]},#{word2[1]}"
        end
      end
    end
    'нет'
  end

  def run_level4(question)
    lines = question.split("\n")
    return run_level3(question) if lines.size == 2
    lines.map! { |line| line.sub('%WORD%', 'WORD') }
    words_count = lines.first.scan(/[\p{Word}\-]+/).size
    query = lines.map { |line| Regexp.new(line.sub('WORD','([\p{Word}]+)')) }
    @wc2lineh[words_count].each do |lh|
      query[0].match(@hash2line_orig[lh]) do |word1|
        query[1].match(@hash2line_orig[@next_line[lh]]) do |word2|
          query[2].match(@hash2line_orig[@next_line[@next_line[lh]]]) do |word3|
            return "#{word1[1]},#{word2[1]},#{word3[1]}"
          end
        end
      end
    end
    'нет'
  end

  def run_level5(question)
    words = question.scan(/[\p{Word}\-]+/)
    words_arr = words.map { |word| word.hash }
    words_count = words.size
    @wc2lineh[words_count].each do |line_hash|
      diff1 = @hash2words_arr[line_hash] - words_arr
      next if diff1.size > 1
      diff2 = words_arr - @hash2words_arr[line_hash]
      next if diff2.size > 1
      return "#{@hash2word[diff1.first]},#{@hash2word[diff2.first]}"
    end
    'нет'
  end

  def run_level6(question)
    chars_arr = question.scan(/./).map(&:hash)
    chars_count = chars_arr.size
    @cc2lineh[chars_count].each do |line_hash|
      diff1 = @hash2chars_arr[line_hash] - chars_arr
      next if diff1.any?
      diff2 = chars_arr - @hash2chars_arr[line_hash]
      next if diff2.any?
      return @hash2line_orig[line_hash]
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

  def to_s
    str = ''
    @verses.each do |v|
      str << "#{v.title}\n\n"
      v.lines_arr.each do |l|
        str << "#{l.line_orig}\n"
      end
      str << "\n\n"
    end
    str
  end

  # indexing @verses
  def init_hash
    prev = @verses[-1].lines_arr[-1].line_hash
    @verses.each do |verse|
      verse.lines_arr.each do |line|
        # line hash => "line"
        @hash2line_orig[line.line_hash] = line.line_orig
        # line hash => "title"
        @hash2title[line.line_hash] = verse.title
        # words count => [line_hash]
        @wc2lineh[line.words_count] ||= []
        @wc2lineh[line.words_count] << line.line_hash
        # line hash => next line hash
        @next_line[prev] = line.line_hash
        prev = line.line_hash
        # word hash => "word"
        line.words_arr.each do |wrd|
          @hash2word[wrd.word_hash] = wrd.word
        end
        # line hash => [word_hash]
        @hash2words_arr[line.line_hash] = line.words_arr.map { |word| word.word_hash }
        # line hash => [char hash]
        @hash2chars_arr[line.line_hash] = line.line_orig.scan(/[\p{^Punct}\-]/).map(&:hash)
        # chars count => [line hash]
        chars_count = @hash2chars_arr[line.line_hash].size
        @cc2lineh[chars_count] ||= []
        @cc2lineh[chars_count] << line.line_hash
      end
    end
    @next_line[prev] = @verses[0].lines_arr[0].line_hash
  end
end
