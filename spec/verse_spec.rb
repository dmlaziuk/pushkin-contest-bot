require 'rspec'
require_relative '../lib/verse'

describe Verse, 'behaviour' do
  let(:test_title) { 'Бакуниной' }
  let(:test_text) do
    ['Напрасно воспевать мне ваши именины',
     'При всем усердии послушности моей;',
     'Вы не милее в день святой Екатерины',
     'Затем, что никогда нельзя быть вас милей.']
  end
  subject { Verse.new(test_title, test_text) }
  it 'should save title' do
    expect(subject.title).to eq(test_title)
  end
  it 'should save lines array' do
    expect(subject.lines_arr.map(&:line_orig)).to eq(test_text)
  end
end
