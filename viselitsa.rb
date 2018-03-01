# Код для отображения русских букв на windows
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

# Подключаем классы Game, ResultPrinter и WordReader
require_relative "lib/game"
require_relative "lib/result_printer"
require_relative "lib/word_reader"
# Подключаем гем unicode для изменения регистра кириллицы
require "unicode"

NAME_GAME = "Игра виселица. \n\n"
sleep 1

# Создаем экземпляр класса WordReader
word_reader = WordReader.new
words_file_name = File.dirname(__FILE__) + "/data/words.txt"
word = word_reader.read_from_file(words_file_name)
# Создаем экземпляр класса Game и передаем ему в качестве параметра слово,
# которое считываем из текстового файла
game = Game.new(word)
# Выводим наименование игры с помощью сеттера name_game=
game.name_game = NAME_GAME
# Создаем экземпляр класса ResultPrinter
printer = ResultPrinter.new(game)

# Запускаем цикл, пока статус игры in_progress, выводим на экран загаданное слово, виселицу и кол-во ошибок.
# Далее спрашиваем пользователя следующую букву
while game.in_progress?
  printer.print_status(game)
  game.ask_next_letter
end
# Как только статус игры становится отличным от нуля, выводим победил пользователь или проиграл,
# в зависимости от результата
printer.print_status(game)
