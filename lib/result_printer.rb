# Класс ResultPrinter, печатающий состояние и результаты игры.
class ResultPrinter
  # В конструкторе мы прочитаем все изображения виселиц и запишем каждое из них
  # в отдельный элемент массива.
  def initialize(game)
    # Создадим переменную экземпляра @status_image — массив, хранящий
    # изображения виселиц.
    @status_image = []

    # Сохраним текущее положение файла программы
    current_path = File.dirname(__FILE__)

    # Создадим переменную для счетчика шагов в цикле
    counter = 0

    # В цикле прочитаем 7 файлов из папки image и запишем их содержимое в массив
    while counter <= game.max_errors do
      # Соберем путь к файлу с изображением виселицы. Каждыый из них лежит в
      # папке /image/ и называется 0.txt, 1.txt, 2.txt и т. д.
      file_name = current_path + "/../image/#{counter}.txt"

      if File.exist?(file_name)
        # Ести такой файл существует, считываем его содержимое целиком и кладем
        # в массив одной большой строкой.
        file = File.new(file_name, "r:UTF-8")
        @status_image << file.read
        file.close
      else
        # Если файла нет, вместо соответствующей картинки будет «заглушка»
        @status_image << "\n [ изображение не найдено ] \n"
      end

      counter += 1
    end
  end

  # Метод print_viselitsa будет рисовать виселицу, соответствующую текущему
  # количеству ошибок.
  def print_viselitsa(errors)
    # Так как ранее (в конструкторе) мы все картинки загрузили в массив
    # @status_image, сейчас чтобы вывести на экран нужную виселицу, достаточно
    # в качестве параметра puts указать нужный элемент этого массива.
    puts @status_image[errors]
  end

  # Основной метод, печатающий состояния объекта класса Game, который нужно
  # передать ему в качестве параметра.
  def print_status(game)
    # Очищаем экран, вызвав метод этого же класса "def cls"
    cls
    puts game.name_game
    puts
    puts "Слово: #{get_word_for_print(game.letters, game.good_letters)}"
    puts "Ошибки: #{game.bad_letters.join(", ")}"

    # Выводим картинку виселицы, соответствующей определенному кол-ву ошибок
    print_viselitsa(game.errors)

    # В зависимости от статуса либо заканчиваем игру, либо продолжаем
    if game.lost?
      puts
      puts "Вы проиграли :("
      puts "Загаданное слово было: " + game.letters.join("")
      puts
    elsif game.won?
      puts
      puts "Поздравляем, вы выиграли!"
      puts
    else
      puts "У вас осталось ошибок: #{game.errors_left}"
    end
  end
  # метод, отвечающий за отображение загаданного слова
  def get_word_for_print(letters, good_letters)
    result = ""

    for item in letters do
      if good_letters.include?(item)
        result += item + " "
      else
        result += "__ "
      end
    end

    return result
  end
  # метод, который очищает экран консоли
  def cls
    system("clear") || system("cls")
  end
end
