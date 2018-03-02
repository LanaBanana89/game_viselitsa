# Класс WordReader, предоставляет функцию для считывания рандомного слова
# из файла(метод read_from_file(file_name)) либо из консоли (read_from_args).
# В данной игре слово считываем из файла
class WordReader
  def read_from_args
    ARGV[0]
  end

  def read_from_file(file_name)
    return unless File.exist?(file_name)
    file = File.readlines(file_name, encoding: 'UTF-8')
    # Возвращаем рандомное слово в нижнем регистре
    Unicode::downcase(file.sample.chomp)
  end
end
