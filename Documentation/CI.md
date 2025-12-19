# CI
## Fastlane

**Файл:** `fastlane/Fastfile`

#### Назначение
Lane `build` — быстрый билд iOS-приложения. Используется для локальной разработки 
и тестирования: максимально ускоряет сборку за счёт переиспользования DerivedData.

#### Запуск
```bash
fastlane ios build
```

#### CI/CD (GitHub Actions)
Проект содержит готовый workflow `.github/workflows/ios-build.yml`, который автоматически:
- Генерирует проект через Tuist (`tuist generate`)
- Устанавливает зависимости
- Выполняет `fastlane ios build` на macOS-15 runner

Триггеры: push в `main` и любой pull request.

Fastlane используется только для одной задачи — быстрой проверки сборки клиента. При необходимости легко расширяется (добавление тестов, деплоя в TestFlight и т.д.).