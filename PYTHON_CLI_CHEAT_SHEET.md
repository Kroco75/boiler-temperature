# 🐍 Python CLI Cheat Sheet (py, pip, venv)

---

## 🔹 1. Python Launcher (`py`)

### Перевірка версій Python

```bash
py -0
```

### Поточна версія за замовчуванням

```bash
py --version
```

### Запуск конкретної версії

```bash
py -3.12
py -3.13
py -3.14
```

### Запуск скрипта

```bash
py script.py
py -3.12 script.py
```

---

## 📦 2. pip (менеджер пакетів)

### Перевірка pip

```bash
py -m pip --version
```

### Встановлення пакета

```bash
py -m pip install requests
```

### Оновлення пакета

```bash
py -m pip install --upgrade requests
```

### Видалення пакета

```bash
py -m pip uninstall requests
```

### Список встановлених пакетів

```bash
py -m pip list
```

### Інформація про пакет

```bash
py -m pip show requests
```

---

## 📁 3. Віртуальне середовище (.venv)

### Створення venv (рекомендовано)

```bash
py -3.12 -m venv .venv
```

### Активація (PowerShell)

```bash
.\.venv\Scripts\Activate.ps1
```

### Активація (cmd)

```bash
.venv\Scripts\activate.bat
```

### Деактивація

```bash
deactivate
```

---

## 📌 4. Робота всередині venv

### Перевірка Python

```bash
python --version
```

### Перевірка pip

```bash
pip --version
```

### Встановлення пакета (локально в проєкт)

```bash
pip install requests
```

---

## 📄 5. Робота з залежностями

### Зберегти залежності

```bash
pip freeze > requirements.txt
```

### Встановити залежності

```bash
pip install -r requirements.txt
```

---

## ⚙️ 6. Оновлення pip

```bash
py -m pip install --upgrade pip
```

---

## 🚫 7. Часті помилки

### ❌ Не робити так

```bash
pip install requests
```

(може використати не ту версію Python)

### ✅ Правильно

```bash
py -m pip install requests
```

---

## 🧠 8. Рекомендований workflow

```bash
# 1. Створити середовище
py -3.12 -m venv .venv

# 2. Активувати
.\.venv\Scripts\Activate.ps1

# 3. Встановити залежності
pip install -r requirements.txt

# 4. Запуск проєкту
python main.py
```

---

## 📍 Примітка

* Кожна версія Python має свій pip
* Кожен venv має свої пакети
* Використовуй venv для кожного проєкту

---

## 🏠 9. ESPHome / Home Assistant tooling

### Встановлення ESPHome (рекомендовано в окремому venv)

```bash
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install esphome
```

### Перевірка версії ESPHome

```bash
esphome version
```

### Перевірка конфігурації YAML

```bash
esphome config your_device.yaml
```

### Запуск/прошивка пристрою

```bash
esphome run your_device.yaml
```

### Логи пристрою (через API)

```bash
esphome logs your_device.yaml
```

### Компіляція без прошивки

```bash
esphome compile your_device.yaml
```

### Оновлення ESPHome

```bash
pip install --upgrade esphome
```

---

### 📡 Робота з Home Assistant (CLI / dev tooling)

> Для HA OS більшість дій виконуються через UI або Add-ons.
> Нижче — корисно для локальної розробки/скриптів.

### Використання REST API (приклад)

```bash
curl -X GET \
  -H "Authorization: Bearer YOUR_LONG_LIVED_TOKEN" \
  -H "Content-Type: application/json" \
  http://homeassistant.local:8123/api/states
```

### Відправка події в HA

```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_LONG_LIVED_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.test"}' \
  http://homeassistant.local:8123/api/services/switch/toggle
```

### Python-скрипт для HA API

```python
import requests

url = "http://homeassistant.local:8123/api/states"
headers = {
    "Authorization": "Bearer YOUR_TOKEN",
    "Content-Type": "application/json",
}

response = requests.get(url, headers=headers)
print(response.json())
```

---

## 🔀 10. Git + Python workflow

### Ініціалізація проєкту

```bash
git init
git add .
git commit -m "init project"
```

### Підключення до GitHub

```bash
git remote add origin git@github.com:USERNAME/REPO.git
git branch -M main
git push -u origin main
```

---

### Структура Python-проєкту

```text
project/
├── .venv/
├── src/
│   └── main.py
├── requirements.txt
├── README.md
└── .gitignore
```

---

### .gitignore (мінімум для Python)

```gitignore
.venv/
__pycache__/
*.pyc
.esphome/
.pioenvs/
.piolibdeps/
*.log
```

---

### Типовий workflow

```bash
# 1. Клонувати репозиторій
git clone git@github.com:USERNAME/REPO.git
cd REPO

# 2. Створити середовище
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1

# 3. Встановити залежності
pip install -r requirements.txt

# 4. Розробка / зміни
# редагуєш код

# 5. Коміт
 git add .
 git commit -m "update feature"

# 6. Пуш
 git push
```

---

### Оновлення залежностей

```bash
pip freeze > requirements.txt
```

---

### Поради

* Не коміть `.venv/` в Git
* Фіксуй залежності через `requirements.txt`
* Для ESPHome тримай YAML в репозиторії
* Для HA скриптів — окремий каталог (`scripts/`)
