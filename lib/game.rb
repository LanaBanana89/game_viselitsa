# Основной класс игры Game. Хранит состояние игры и предоставляет функции для
# процесса игры (ввод новых букв, подсчет кол-ва ошибок и т. п.).
class Game
  # Cеттеры для получения информации об игре
  attr_reader :errors, :letters, :good_letters, :bad_letters, :status
  # Сеттер и Геттер  для поля name_game
  attr_accessor :name_game

  # Константа с максимальным количеством ошибок
  MAX_ERRORS = 7

  def initialize(slovo)
    # В @letters будет лежать массив букв
    # загаданного слова. Для того, чтобы его создать, вызываем метод get_letters
    # этого же класса.
    @letters = get_letters(slovo)
    # Переменная @errors будет хранить текущее количество ошибок, всего можно
    # сделать не более 7 ошибок. Начальное значение — 0.
    @errors = 0
    # Переменные @good_letters и @bad_lettes будут содержать массивы, хранящие
    # угаданные и неугаданные буквы. В начале игры они пустые.
    @good_letters = []
    @bad_letters = []
    # В поле @status лежат символы, которые
    # наглядно показывают статус
    # :in_progress — игра продолжается
    # :won — игра выиграна
    # :lost — игра проиграна
    @status = :in_progress
  end
  
  # Метод, который возвращает массив букв загаданного слова
  def get_letters(slovo)
    if slovo == nil || slovo == ""
      abort "Загадано пустое слово, нечего отгадывать. Закрываемся"
    end

    slovo.encode('UTF-8').split("")
  end
  
  # Метод, который отвечает на вопрос, является ли буква подходящей
  def is_good?(letter)
    @letters.include?(letter) ||
    (letter == "е" && @letters.include?("ё")) ||
    (letter == "ё" && @letters.include?("е")) ||
    (letter == "и" && @letters.include?("й")) ||
    (letter == "й" && @letters.include?("и"))
  end
  
  # Метод добавляет букву к массиву подходящих букв
  def add_good_letter(letter)
    # Если в слове есть буква запишем её в число "правильных" либо "неправильных" буква
      @good_letters << letter

      case letter
      when 'е' then @good_letters << 'ё'
      when 'ё' then @good_letters << 'е'
      when 'и' then @good_letters << 'й'
      when 'й' then @good_letters << 'и'
      end
  end
        
  # Метод добавляет букву к массиву букв, которых нет в загаданном слове
  def add_bad_letter(letter)
    @bad_letters << letter
  end
        
  # Метод, который отвечает на вопрос, отгадано ли все слово
  def solved?
    (@letters - @good_letters).empty?
  end
        
  # Метод, который отвечает на вопрос, была ли уже эта буква, также
  # буквы "е" и "ё" и "и" и "й" считаются за одну
  def repeated?(letter)
    @good_letters.include?(letter) ||
    @bad_letters.include?(letter) ||
    (letter == "е" && @bad_letters.include?("ё")) ||
    (letter == "ё" && @bad_letters.include?("е")) ||
    (letter == "и" && @bad_letters.include?("й")) ||
    (letter == "й" && @bad_letters.include?("и"))
  end
        
  # Метод, который отвечает на вопрос, проиграна ли игра
  def lost?
    @status == :lost || @errors >= MAX_ERRORS
  end
        
  # Метод, который возвращает константу MAX_ERRORS
  def max_errors
    MAX_ERRORS
  end
        
  # Метод, который возвращает количество оставшихся ошибок
  def errors_left
    MAX_ERRORS - @errors
  end
        
  # Метод, который отвечает на вопрос, продолжается ли игра
  def in_progress?
    @status == :in_progress
  end
        
  # Метод, который отвечает на вопрос, выиграл ли игрок
  def won?
    @status == :won
  end
        
  # Основной метод игры "сделать следующий шаг". В качестве параметра принимает
  # букву, которую ввел пользователь.
  def next_step(letter)
    # Предварительная проверка: если статус игры равен :lost или :won, значит игра
    # закончена и нет смысла дальше делать шаг. Выходим из метода возвращая
    # пустое значение.
    return if @status == :lost || @status == :won

    # если пользователь ввёл одну и ту же букву, то не учитываем её в массивах
    # @good_letters и @bad_letters, так же не учитываем букву "е", если ранее была
    # введена "ё" и наоборот, аналогично не учитываем букву "и", если ранее была введена "й"
    # и наоборот
    return if repeated?(letter)

    if is_good?(letter)
      add_good_letter(letter)
      # Проверяем - угадано ли на этой букве все слово целиком.
      # Если да — меняем значение переменной @status на :won — победа.
      @status = :won if solved?
    else
      # Если в слове нет введенной буквы — добавляем эту букву в массив
      # «плохих» букв и увеличиваем счетчик ошибок.
      add_bad_letter(letter)
      @errors += 1
      # Если ошибок больше 7 — статус игры меняем на :lost, проигрыш.
      @status = :lost if lost?
    end
  end
        
  # Метод, спрашивающий пользователя букву и возвращающий ее как результат.
  def ask_next_letter
    puts "\nВведите следующую букву"

    letter = ""
    while letter == ""
      # C помощью гема "unicode" приводим вводимую пользователем букву в
      # нижний регистр(для работы с кириллицей)
      letter = Unicode::downcase(STDIN.gets.encode("UTF-8").chomp)
    end
    # После получения ввода, передаем управление в основной метод игры
    next_step(letter)
  end
end
