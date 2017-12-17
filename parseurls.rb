require 'json'
require 'mechanize'
require 'open-uri'

links = %w[https://ru.wikisource.org/wiki/Стихотворения_Пушкина_1826—1836
#https://ru.wikisource.org/wiki/Стихотворения_Пушкина_1809—1825
#https://ru.wikisource.org/wiki/Полтава_(Пушкин)
#https://ru.wikisource.org/wiki/Кавказский_пленник_(Пушкин)
#https://ru.wikisource.org/wiki/Евгений_Онегин_(Пушкин)
#https://ru.wikisource.org/wiki/Александр_Сергеевич_Пушкин
]

agent = Mechanize.new
urls = Hash.new

links.each do |link|
  page = agent.get(link)
  ll = page.links_with(xpath: '//ul/li/a')
  ll.each do |l|
    title = l.text
    url = "https://ru.wikisource.org#{URI::decode(l.uri.to_s)}"
    urls[title] = url
  end
  ll = page.links_with(xpath: '//ul/li/*/a')
  ll.each do |l|
    title = l.text
    url = "https://ru.wikisource.org#{URI::decode(l.uri.to_s)}"
    urls[title] = url
  end
end
File.open("lyrics.json","w") do |f|
  f.write(urls.to_json)
end
