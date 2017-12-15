require_relative 'line'

class Verse
  attr_reader :title
  attr_reader :lines_arr

  def initialize(title, text)
    @title = title
    @lines_arr = []
    text.each_line do |line|
      @lines_arr << Line.new(line.strip)
    end
  end
end
