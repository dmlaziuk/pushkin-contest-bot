require_relative 'line'

class Verse
  attr_reader :title
  attr_reader :lines_arr

  def initialize(title, text)
    @title = title
    @lines_arr = text.map { |line| Line.new(line) }
  end
end
