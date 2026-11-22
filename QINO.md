# QINO ТВ in FxmlKino

[Русская версия](QINO.ru.md) · [Back to README](README.md)

**QINO ТВ** shows the live channels, films, series and TV recordings of [qino.live](https://qino.live/)
on the «FXML Кино» portal. It needs a qino.live account (by phone number).

## Logging in

On the TV, open **QINO ТВ** → **Войти**, then one of:

- **Войти с компьютера или телефона**: the page shows an address such as
  `http://192.168.1.10:8787/qino/login`. Open it in a browser on a phone or PC on the same network,
  enter your phone number, the picture code and the SMS code. Then press **Я вошёл** on the TV.
- **Войти на телевизоре**: enter the phone number, the picture code and the SMS code with the remote,
  then **Я вошёл**.

Second TV (Samsung, LG or Android): after logging in, the browser login page shows the **session code**.
On the other TV open its login page in a browser, unfold «Уже вошли на другом ТВ или на qino.live?
Вставить код сессии», paste the code and press **Я вошёл** on that TV.

**Выйти** on the TV forgets the login on that TV. **Выйти на всех ТВ** on the browser login page ends the
session everywhere (all TVs and browsers that use it).

## What's there

Search, all channels, favourites, channel genres, films and series, TV recordings. Choose the audio
language and quality in a channel's page.

Good to know:
- Stream links are made for your home's internet address, so the app reads them from home (the TV
  itself). They don't work if the TV uses a VPN with another country.
- Only what your qino.live subscription includes plays.
- Android: the login page is at `http://<device-IP>:8787/qino/login` (the QINO login page in the app
  shows the address).
