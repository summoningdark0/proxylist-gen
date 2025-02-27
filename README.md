Usage: 
You will need to install imagemagick: https://imagemagick.org/

Download generate-proxy.sh  
Edit it with your path, change variavble "directory". At this point script uses all the files in selected directory.   
Run in terminal:  
> chmod +x generate-proxy.sh  
> ./generate-proxy.sh
  
The script will output the result in the directory it is in. 
  
Tested on MacOS only (so far) 
  

---


Как пользоваться:   
Для работы скрипта нужен imagemagick: https://imagemagick.org/  
  
Скачайте generate-proxy.sh  
Отредактируйте, назначив в переменную "directory" свой путь. Скрипт будет использовать все файлы в указаной директории.  
Далее в терминале:  
> chmod +x generate-proxy.sh  
> ./generate-proxy.sh
  
Скрипт положит результаты в одну директорию с собой. 

Проверено только на MacOS

---

Changelog

v1.1
• Now you can choose path to the folder with images
• Path to the said folder could also be passed to the script, e.g. "./generate-proxy images" or "./generate-proxy /Users/banana/Documents/Netrunner/images" 
• added png support
• added timestamps to resulting pages to prevent accidental overwrites on multiple script runs

• Теперь можно выбирать папку с картинками для проксей 
• Скрипт принимает путь к папке как параметр, например "./generate-proxy images" или "./generate-proxy /Users/banana/Documents/Netrunner/images" 
• работает с png файлами
• добавил время к имени итоговых страниц, чтобы избежать случайной перезаписи при повтором запуске скрипта
