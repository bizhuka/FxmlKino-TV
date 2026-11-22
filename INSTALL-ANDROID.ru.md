# FxmlKino на Android TV, ТВ-приставках и телефонах

[English version](INSTALL-ANDROID.md) · [Назад к README](README.ru.md)

`FxmlKino.apk` (в каждом [релизе](https://github.com/bizhuka/FxmlKino-TV/releases/latest)) — это
[Fork browser](https://wiki.forkbrowser.top/) для Android со встроенным FxmlKino: парсер работает внутри
приложения, а портал «FXML Кино» открывается при запуске. Нужен Android 5.0 или новее. Ставится рядом с
Fork browser, если он у вас есть, и не заменяет его.

**Телефон или планшет:**
1. На телефоне скачайте [`FxmlKino.apk`](https://github.com/bizhuka/FxmlKino-TV/releases/latest/download/FxmlKino.apk).
2. Откройте файл. Когда Android спросит, разрешите установку приложений из этого источника (браузера или
   файлового менеджера), затем установите.
3. Откройте **FxmlKino**.

**Android TV или ТВ-приставка** (любой способ):
- Приложение **Downloader** (от AFTVnews, есть в Google Play на ТВ): введите
  `https://github.com/bizhuka/FxmlKino-TV/releases/latest/download/FxmlKino.apk`, установите и разрешите
  Downloader устанавливать приложения, когда спросит.
- Скопируйте `FxmlKino.apk` на флешку и откройте его на ТВ файловым менеджером (например, X-plore или
  File Commander).
- С компьютера через `adb`: на ТВ включите «Для разработчиков» → отладку по сети (USB), затем
  `adb connect <IP-ТВ>:5555` и `adb install FxmlKino.apk`.

Обновление: установите новый `FxmlKino.apk` поверх старого.

Полезно знать:
- Собственные сообщения Fork browser (подсказки при первом запуске, окно пожертвований) появляются как в
  Fork browser.
- Если Fork browser предложит обновление, оно поставит оригинальный Fork browser рядом с FxmlKino.
  Обновления FxmlKino выходят в релизах этого репозитория.
- Торренты: когда торрент впервые попросит, выберите **Установить Fork Torrserve**: приложение один раз
  скачает официальный [TorrServer](https://github.com/YouROK/TorrServer) (около 60 МБ). Он работает, пока
  FxmlKino на экране, и останавливается через минуту после выхода из приложения, если торрент уже не
  играет. Выключить или удалить его можно в Настройки → **TORRSERVE_IP**.
- На Android 13 и новее FxmlKino может спросить разрешение на уведомления. Работает с любым ответом.
