# График смен + зарплата — Cloud v7

Основа: версия 6 приложения. Добавлены Supabase Auth, облачная синхронизация, гостевой режим, PWA и мобильная адаптация.

## 1. Supabase
1. Создайте проект в Supabase.
2. Откройте SQL Editor и выполните `schema.sql`.
3. В Project Settings -> API скопируйте Project URL и публичный anon/publishable key.
4. Впишите их в `config.js`:
   `window.SUPABASE_CONFIG = { url: '...', anonKey: '...' }`
5. В Authentication -> URL Configuration добавьте URL опубликованного сайта в Site URL/Redirect URLs.

## 2. GitHub Pages
Загрузите содержимое этой папки в репозиторий (лучше публичный при GitHub Free) и включите Pages для ветки `main`, папка `/`.

## 3. Что хранится где
- Сайт: GitHub Pages.
- Аккаунты и данные графика: Supabase (Auth + PostgreSQL).
- В браузере остаётся локальный кэш как offline/гостевой режим.

## Безопасность
В `config.js` разрешён только публичный anon/publishable key. `service_role` на клиент помещать нельзя.

## Гостевой режим
Без входа приложение работает локально в браузере. Для синхронизации между устройствами нужен аккаунт.
