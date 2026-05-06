# AGENTS.md

Правила для AI-агентів, які працюють з репозиторієм `boiler-temperature`.

## Контекст проєкту

Це ESPHome-проєкт для моніторингу температури системи опалення та ГВП.

Апаратна частина:

- ESP32-C3 MINI.
- ESPHome з framework `esp-idf`.
- 4 датчики DS18B20 на 1-Wire.
- Один 1-Wire bus на `GPIO4`.
- SPI дисплей ILI9341.
- Home Assistant через native API.

Піни дисплея:

- SPI CLK: `GPIO6`.
- SPI MOSI: `GPIO7`.
- CS: `GPIO3`.
- DC: `GPIO5`.
- RESET: `GPIO2`.

Адреси DS18B20 вже відомі та винесені в `substitutions` у `esphome/boiler-temperature.yaml`.

Важлива поточна проблема: 1-Wire шина працює нестабільно при підключенні всіх 4 датчиків. Будь-які зміни мають зберігати пріоритет стабільності датчиків і не додавати зайве навантаження на ESP32-C3.

## Структура проєкту

Основні каталоги:

- `esphome/` - ESPHome YAML конфігурація.
- `docs/` - документація.
- `hardware/` - пін-аут, схема, фізичне підключення.
- `logs/` - локальні логи для дебагу.
- `scripts/` - утиліти та shell-скрипти.

ESPHome-структура:

- `esphome/boiler-temperature.yaml` - головний конфіг.
- `esphome/boiler-temperature/packages/` - модулі ESPHome YAML.
- `esphome/boiler-temperature/common/` - спільні YAML-фрагменти.
- `esphome/boiler-temperature/images/` - зображення для дисплея.
- `esphome/secrets.yaml` - локальні секрети, не комітити.

## Python та ESPHome

Проєкт використовує локальне Python-середовище:

```powershell
esphome/venv/
```

Правила:

- Усі Python-команди для цього проєкту виконувати через локальний `venv`.
- Не використовувати глобальний Python для ESPHome-команд цього проєкту.
- Не встановлювати Python-пакети глобально.
- Не змінювати залежності без необхідності.
- Якщо потрібні нові Python-інструменти, встановлювати їх тільки в `esphome/venv`.
- Не комітити `venv/` або `.venv/` у Git.

Типовий запуск у PowerShell:

```powershell
cd C:\Users\admin\Desktop\myProject\boiler-temperature\esphome
.\venv\Scripts\Activate.ps1
esphome config boiler-temperature.yaml
esphome compile boiler-temperature.yaml
```

Якщо PowerShell блокує `Activate.ps1`, використовувати:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Після цього повторити активацію `venv`.

## Правила роботи з ESPHome YAML

- Зберігати модульну структуру YAML.
- Не переносити все назад в один великий YAML-файл.
- Нові сенсори, дисплей, Wi-Fi, діагностику додавати у відповідні файли в `packages/`.
- Повторно використовувані частини додавати в `common/`.
- Секрети підключати тільки через `!secret`.
- Не додавати реальні паролі, API keys або OTA passwords у Git.
- Після зміни YAML запускати:

```powershell
esphome config boiler-temperature.yaml
```

- Після зміни `lambda`, дисплея, image/font або platform-компонентів запускати також:

```powershell
esphome compile boiler-temperature.yaml
```

## Дисплей

Дисплей ILI9341 працює в орієнтації `rotation: 270`, робоча область `320x240`.

Важливі правила:

- Дисплей не повинен впливати на стабільність DS18B20.
- Не робити важку графіку в `lambda`, якщо її можна винести у PNG-фон.
- Не зменшувати `update_interval` без причини.
- Поточний підхід для нового екрана: фон PNG у `images/`, поверх виводяться тільки температури.
- Якщо змінюється фон дисплея, перевірити розмір зображення: має бути `320x240`.
- Після змін дисплея обов'язково запускати `esphome compile`.

## 1-Wire та датчики

Пріоритет проєкту - стабільна робота 1-Wire.

Правила:

- Не змінювати `GPIO4` для 1-Wire без явної причини.
- Не змінювати адреси DS18B20 без перевірки логів.
- Не зменшувати `update_interval` датчиків без потреби.
- Обережно додавати компоненти, які можуть навантажувати CPU або блокувати loop.
- Якщо з'являються `85°C`, `-127°C` або пропуски сенсорів, спершу аналізувати 1-Wire шину, живлення, підтяжку і топологію.

## Скрипти та Home Assistant

Скрипти зберігаються в `scripts/`.

Для Home Assistant використовується скрипт:

```text
scripts/update_boiler_temperature.sh
```

Важливо:

- Shell-скрипти для HA мають бути у форматі LF, без BOM.
- Не використовувати Windows CRLF для `.sh`.
- Скрипт зараз може бути налаштований на тестову гілку `new_screen`.
- Після merge `new_screen` у `main` потрібно змінити:

```sh
BRANCH="new_screen"
```

на:

```sh
BRANCH="main"
```

## Git та файли, які не можна комітити

Не комітити:

- `esphome/secrets.yaml`.
- `esphome/venv/`.
- `.venv/`.
- `.esphome/`.
- `.pioenvs/`.
- `.piolibdeps/`.
- локальні логи з `logs/`.
- build-файли `*.bin`, `*.elf`.

Перед фінальним звітом бажано перевіряти:

```powershell
git status --short
```

## Пріоритети змін

Порядок важливості:

1. Стабільність DS18B20 і 1-Wire.
2. Коректність температур.
3. Сумісність із Home Assistant та ESPHome Builder.
4. Керована структура YAML і Git.
5. Дисплей і візуальні покращення.

Якщо зміна може погіршити стабільність датчиків, її не слід робити без окремого погодження.

