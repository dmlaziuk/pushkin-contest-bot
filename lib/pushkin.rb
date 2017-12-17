require_relative 'verse'

class Pushkin
  def initialize()
    @vol = []
    @line2title = Hash.new
    @lines_hash = Hash.new
    @words_hash = Hash.new
    @chars_hash = Hash.new
  end

  def run
    init_test
    init_hash
    print_verse
    print_hash
  end

  def init_test
    title = 'Узник'
    text = "Сижу за решёткой в темнице сырой.\n"\
    "Вскормленный в неволе орёл молодой,\n"\
    "Мой грустный товарищ, махая крылом,\n"\
    "Кровавую пищу клюёт под окном,\n"\
    "\n"\
    "Клюёт, и бросает, и смотрит в окно,\n"\
    "Как будто со мною задумал одно.\n"\
    "Зовёт меня взглядом и криком своим\n"\
    "И вымолвить хочет: «Давай, улетим!\n"\
    "\n"\
    "Мы вольные птицы; пора, брат, пора!\n"\
    "Туда, где за тучей белеет гора,\n"\
    "Туда, где синеют морские края,\n"\
    "Туда, где гуляем лишь ветер… да я!…»"

    @vol << Verse.new(title, text)
  end

  def print_verse
    @vol.each do |v|
      puts v.title
      puts
      v.lines_arr.each do |l|
        puts l.line
      end
    end
  end

  def init_hash
    vol.each do |v|
      v.lines_arr.each do |l|
        line2title[l.hash] = v.title
        lines_hash[l.hash] = l.line
        l.words_arr.each do |w|
          words_hash[w.hash] = w.word
          w.chars_arr.each_with_index do |c, i|
            chars_hash[c] = w.word[i]
          end
        end
      end
    end
  end

  def print_hash
    puts 'Line2Title:'
    puts line2title
    puts 'Lines:'
    puts lines_hash
    puts 'Words:'
    puts words_hash
    puts 'Chars:'
    puts chars_hash
  end
end
