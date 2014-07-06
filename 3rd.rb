# coding: utf-8
#!/usr/bin/env ruby
require 'net/http'

# Реализовать Ruby скрипт, использующий api сайта http://pastebin.com/. 
# Скрипт должен выкладывать входящую строку на этот сервис, на выходе 
# скрипт должен выдавать соответствующую ссылку.

# Проверка на существование аргументов, которые, по условиям задачи, не должны влиять на работу программы
if ARGV.count != 0
  print "Введенные Вами аргументы:"
  ARGV.each do|a|
    print " #{a},"
  end
  puts " не используются в данной программе"
end

# Адрес API сайта Pastebin
uri = URI('http://pastebin.com/api/api_post.php')

# Инициализация необходимых переменных, необходимых для формирования запроса
api_dev_key = '48eb38e51b11a40ee61eb28f17c92e07' # Персональный api_developer_key
api_paste_expire_date = '10M'
api_paste_format = 'php' # Формат документа
api_user_key = ''
api_paste_private = '0' # 0=public 1=unlisted 2=private

# Бесконечный цикл, который может прервать только корректный ввод данных
loop do
  puts "Введите название документа: "
  # Переменная @api_paste_name объявлена как переменная экземпляра
  @api_paste_name = STDIN.gets.chomp
  
  # Если введенный текст не является пустой строкой и не превышает лимиты, то выходим из цикла
  unless @api_paste_name.empty?
    if @api_paste_name.length < 100
      break
    else
      puts "Превышен лимит длины названия"
    end    
  # В противном случае выводим сообщение об ошибке
  else
    puts "Введена пустая строка"
  end
end

# Заполнение содержимого документа
loop do
  puts "Введите содержимое документа: "
  @api_paste_code = STDIN.gets.chomp
  
  # Если введенный текст не является пустой строкой и не превышает лимиты, то выходим из цикла
  unless @api_paste_code.empty?
    if @api_paste_code.length < 500
      break
    else
      puts "Превышен лимит длины документа"
    end    
  # В противном случае выводим сообщение об ошибке
  else
    puts "Введена пустая строка"
  end
end

# Используется механизм исключений для обработки ошибок соединения.
begin
  # Формирование и создание запроса к API через POST-запрос.
  # Переменная res содержит ответ от сервера
  res = Net::HTTP.post_form(uri,
                            'api_option' => 'paste',
                            'api_user_key' => api_user_key,
                            'api_paste_private' => api_paste_private,
                            'api_paste_name' => @api_paste_name,
                            'api_paste_expire_date' => api_paste_expire_date,
                            'api_paste_format' => api_paste_format,
                            'api_dev_key' => api_dev_key,
                            'api_paste_code' => @api_paste_code
                          )
  # Проверка на успешность запроса (а точнее соединения)
  if res.code == '200'
    # Записываем body документа, если оно существует
    puts res.body if res.is_a?(Net::HTTPSuccess)
  else
    puts "Some error appears: #{res.body}"
  end
# Если произошло исключение, то выводим его на консоль
rescue => err
  puts "Exception: #{err}"
  err
end