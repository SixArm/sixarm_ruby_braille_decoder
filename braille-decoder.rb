#!/usr/bin/env ruby
#
# Translate an old braille-reader text storage format
# from a braille encoded format to plain text.
#
# Author: Joel Parker Henderson (joelparkerhenderson@gmail.com)
# License: Open source; use any of BSD, GPL, MIT.
#
# For details:
#   http://www.reddit.com/r/programming/comments/cbuu1/not_a_programmer_myself_hope_you_programmers_can/
#
# For samples of input and output:
#   http://www.pastebin.org/311035

TRANSLATE_TRIGGERS = {
  "h" => "", # the next letter is a capital letter
  "|" => "", # begin translating each character to a number
  "@" => "", # end translating a character to a number
}

TRANSLATE_LETTERS = {
  "r" => ".",
  "@" => " ",
  "D" => "'",
  "B" => ",",
  "A" => "a",
  "C" => "b",
  "(unknown)" => "c",
  "Y" => "d",
  "Q" => "e",
  "K" => "f",
  "[" => "g",
  "S" => "h",
  "J" => "i",
  "Z" => "j",
  "E" => "k",
  "G" => "l",
  "M" => "m",
  "]" => "n",
  "U" => "o",
  "O" => "p",
  "(unknown)" => "q",
  "W" => "r",
  "N" => "s",
  "^" => "t",
  "e" => "u",
  "g" => "v",
  "z" => "w",
  "(unknown)" => "x",
  "(unknown)" => "y",
  "u" => "z",
}


TRANSLATE_NUMBERS = {
  "Z" => "0",
  "(unknown)" => "1",
  "C" => "2",
  "I" => "3",
  "(unknown)" => "4",
  "(unknown)" => "5",
  "(unknown)" => "6",
  "(unknown)" => "7",
  "(unknown)" => "8",
  "J" => "9",
}

def translate_string(str)
  translated = ""
  translations = TRANSLATE_LETTERS
  chars = str.split(//)
  while (char = chars.shift)
    case char
    when "h"
      next_char_is_capital = true
    when "|"
      translations = TRANSLATE_NUMBERS
    when "@"
      translations = TRANSLATE_LETTERS
      translated += " "
    else
      c2 = translations[char] || "?"
      if next_char_is_capital
        translated += c2.upcase
        next_char_is_capital = false
      else
        translated += c2
      end
    end
  end
  return translated
end


# Load Ruby's built-in XML processor, which is called REXML.
# FYI, Ruby also has third-party libraries (called gems)
# that are more efficient at XML, e.g. Hpricot and Nokogiri.

require 'rexml/document'

def translate_document(doc)
  translated = ""
  doc.root.elements.each do |element|
    case element.name
    when 'TEXT'
      translated += translate_string(element.get_text.to_s)
    when 'BR'
      translated += "\n"
    end
  end
  return translated
end


# MAIN
#
# Parse the standard input stream to an XML document.
# The document is a nested collection of elements.

filename = ARGV.shift
file = File.new(filename)
document = REXML::Document.new(file)
translated = translate_document(document)
puts translated








