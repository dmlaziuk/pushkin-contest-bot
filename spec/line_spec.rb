require 'rspec'
require_relative '../lib/line'

describe Line, 'behaviour' do
  let(:test_line) { '«Мой дядя самых честных правил,' }
  let(:test_words_arr) { test_line.scan(/[\p{Word}\-]+/) }
  let(:test_line_wo_punctuation) { test_words_arr.join(' ') }
  subject { Line.new(test_line) }
  it 'should save original line' do
    expect(subject.line_orig).to eq(test_line)
  end
  it 'should save line without punctuation' do
    expect(subject.line).to eq(test_line_wo_punctuation)
  end
  it 'should save hash of line without punctuation' do
    expect(subject.line_hash).to eq(test_line_wo_punctuation.hash)
  end
  it 'should save words count' do
    expect(subject.words_count).to eq(test_words_arr.size)
  end
  it 'should save words array' do
    expect(subject.words_arr.map(&:word)).to eq(test_words_arr)
  end
end
