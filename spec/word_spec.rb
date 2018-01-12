require 'rspec'
require_relative '../lib/word'

describe Word, 'behaviour' do
  let(:test_word) { 'дядя' }
  subject { Word.new(test_word) }
  it 'should save original word' do
    expect(subject.word).to eq(test_word)
  end
  it 'should save hash of the word' do
    expect(subject.word_hash).to eq(test_word.hash)
  end
  it 'should save length of the word' do
    expect(subject.word_length).to eq(test_word.length)
  end
  it 'should save array of hashes of each character' do
    expect(subject.chars_hash_arr).to eq(test_word.scan(/./).map(&:hash))
  end
end
