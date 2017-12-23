Pushkin Contest Bot
===================

# Implementation

Class Verse:
* title — title of the verse ( String )
* lines_arr — array of Line's ( [Line] )

Class Line:
* line_orig — original line with punctuation ( String )
* line — line without punctuation ( String )
* line_hash — line.hash ( Integer )
* words_count — words count ( Integer )
* words_arr — array of Word's ( [Word] )

Class Word:
* word — word itself ( String )
* word_hash — word.hash ( String )
* word_length — word.length ( String )
* chars_hash_arr — array of word[i].hash ( [Integer] )

Class Pushkin:
* @verses — array of all verses ( [Verse] )
* @hash2line — line hash to line string ( {Integer => String} )
* @hash2word — word hash to word string ( {Integer => String} )
* @hash2title — line hash to title ( {Integer => String})
* @wc2lineh — words count to array of line hashes ( Integer => [Integer] )
* @next_line — line hash to next line hash ({Integer => Integer}  )
* @hash2words_arr — line hash to array of word hashes ( Integer => [Integer] )
* @hash2chars_arr — line hash to array of char hashes ( Integer => [Integer] )
* @cc2lineh — chars count of line to array of line hashes ( Integer => [Integer] )
