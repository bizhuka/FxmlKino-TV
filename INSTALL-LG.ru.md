# FxmlKino на телевизоре LG (webOS)

[English version](INSTALL-LG.md) · [Назад к README](README.ru.md)

`FxmlKino.ipk` (в этом репозитории и в каждом [релизе](https://github.com/bizhuka/FxmlKino-TV/releases/latest))
— то же приложение для телевизоров LG на webOS, с тем же парсером на самом телевизоре.

1. **Режим разработчика на телевизоре** (один раз):
   1. Зарегистрируйтесь на [сайте разработчиков LG webOS TV](https://webostv.developer.lge.com/).
   2. На телевизоре установите приложение **Developer Mode** из LG Content Store, откройте его и войдите
      под этой учётной записью.
   3. Включите **Dev Mode Status** — телевизор перезагрузится. Снова откройте приложение и включите
      **Key Server**: внизу слева появится **пароль** (passphrase) из 6 символов.
2. **Установка** через [webOS Dev Manager](https://github.com/webosbrew/dev-manager-desktop/releases/latest)
   (Windows, macOS, Linux):
   1. Добавьте телевизор: его IP (ТВ: Настройки → Общие → Сеть → Состояние сети) и пароль.
   2. Откройте **Apps**, установите `FxmlKino.ipk` и запустите **FxmlKino** на телевизоре.
3. Когда парсер работает, на заставке внизу слева видно `FXML: сервис работает`, затем открывается
   портал «FXML Кино».

Приложения из режима разработчика остаются на телевизоре, пока идёт сессия Developer Mode (до 1000
часов). Время от времени открывайте Developer Mode и нажимайте **EXTEND**. Если сессия закончится,
телевизор удалит приложение — после повторного включения режима разработчика установите его снова. На
телевизоре с root и [Homebrew Channel](https://github.com/webosbrew/webos-homebrew-channel) приложения
остаются навсегда: установите `.ipk` через него.

## Торренты на LG

Когда торрент впервые попросит, выберите **Установить Fork Torrserve**: приложение один раз скачает
официальный [TorrServer](https://github.com/YouROK/TorrServer) (около 60 МБ). Он хранится во внутренней
памяти телевизора, поэтому при обновлении приложения заново не скачивается. Работает, пока открыт
FxmlKino, и останавливается через 30 секунд после закрытия. Выключить или удалить его можно в Настройки →
**TORRSERVE_IP**.

<details>
<summary>Через командную строку вместо Dev Manager (webOS CLI от LG)</summary>

```
npm install -g @webos-tools/cli
ares-setup-device -a lgtv -i "host=<IP-телевизора>" -i "port=9922" -i "username=prisoner"
ares-novacom --device lgtv --getkey          # введите пароль (passphrase)
ares-install --device lgtv FxmlKino.ipk
ares-launch --device lgtv com.fxmlkino.tv
```
</details>
