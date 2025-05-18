# PDF.epf

![illustration](https://github.com/user-attachments/assets/902e64a8-beb3-4a5f-a638-c930dcebfb94)

Відображення файлів PDF безпосередньо в 1С для старих платформ

## Підтримувані платформи

Протестовано на 8.3 від 8.3.11, на Windows 7 (з встановленим Internet Explorer 11), 10, та 11
**Поки підтримуються тільки звичайні форми**

## Build

Спочатку треба сформувати ресурси обробки, це архів переглядача PDF.js, адаптований
для використання в межах обробки 1С, та приклад PDF файлу для перегляду

Для цього рекомендується використовувати WSL, хоча можна обійтись віртуальною машиною
з сучасним дистрибутивом GNU/Linux

Наступні інструкції вважатимуть що у вас є "пустий" дистрибутив Debian в WSL2,
адаптовуйте відповідно

1. В WSL встановити curl, unzip, zip, patch
    ```bash
    sudo apt install curl unzip zip patch
    ```
2. В WSL встановити Node Version Manager
    Див. [Інструкція по встановленню NVM](https://github.com/nvm-sh/nvm#install--update-script)
3. В WSL встановити Node.js
    ```bash
    nvm install lts/fermium # Остання версія під якою збирається потрібна версія PDF.js
    ```
4. Скопіювати каталог **build_linux** в домашній каталог WSL (/home/&lt;USER&gt;)
    Для цього можна використати файловий менеджер або PowerShell (на хості)
    ```powershell
    Copy-Item .\build_linux \\wsl.localhost\Debian\home\<USER>\ -Recurse
    ```
5. В WSL перейти в папку **~/build_linux** та виконати скрипт **build.sh**
    ```bash
    cd build_linux
    chmod u+x build.sh
    ./build.sh
    ```
6. Скопіювати файли resources.zip та sample.pdf в папку **build**
    Для цього можна використати файловий менеджер або PowerShell (на хості)
    ```powershell
    New-Item build -ItemType Directory -ErrorAction SilentlyContinue
    Copy-Item \\wsl.localhost\Debian\home\<USER>\build_linux
    @("resources.zip", "sample.pdf") | ForEach-Object { Copy-Item "\\wsl.localhost\Debian\home\<USER>\build_linux\$_" .\build\ }
    ```
7. На хості Створити файл .env з наступним вмістом:
    ```
    1C_HOME=C:\Program Files[ (x86)]\1cv8\x.y.zz.wwww
    ```
8. На хості запустити файл **build.ps1**
9. Файл обробки .epf має з'явитися в папці `build`

## TODO

* Генерація CSS для кращої візуальної інтеграції з платформою
* Вилалення не працюючих елементів інтерфейсу
* Програмний інтерфейс, щоб це діло можна було використовувати в проді
