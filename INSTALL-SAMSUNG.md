# FxmlKino on a Samsung TV (Tizen)

[Русская версия](INSTALL-SAMSUNG.ru.md) · [Back to README](README.md)

Use **TizenBrew Installer**: it works on any Samsung TV from 2017 on, including 2022+, and creates the
certificate for **your** TV itself. The TV needs **Developer Mode** once (see below).

1. Turn on [Developer Mode](#developer-mode) with the IP of your PC (or Android phone) as **Host PC IP**.
2. Download [TizenBrew Installer](https://github.com/reisxd/TizenBrewInstaller/releases/latest) for your
   system and run it. Connect it to your TV.
3. Choose to install an app **from GitHub** and enter:
   ```
   bizhuka/FxmlKino-TV
   ```
   It downloads `FxmlKino.wgt` from this repository's latest
   [release](https://github.com/bizhuka/FxmlKino-TV/releases/latest) and installs it.
4. On TVs from 2022 on (Tizen 7+) it asks you to sign in to a Samsung account and creates a certificate
   for your TV. Follow the on-screen steps.
5. Start **FxmlKino** on the TV. The splash screen shows `FXML: …` at the bottom left while the parser
   starts, then the «FXML Кино» portal opens.

To update, repeat step 3: it installs the newest release over the old one and keeps your settings.

## Developer Mode

Once per TV:

1. Open **Apps** (Home → Apps).
2. Type **1 2 3 4 5** on the remote. On a Smart Remote, press the **123** button for digits.
3. Set **Developer mode** to **On** and enter **Host PC IP**: the IP of the PC (or phone) you install
   from. On Windows, `ipconfig` shows it ("IPv4 Address").
4. Restart the TV: hold the power button until it turns off and on again.

## Torrents on Samsung

A Samsung TV doesn't let an app run TorrServer, so FxmlKino has its own torrent client, which answers the
way TorrServer does. The first time a torrent asks for it, choose **Установить Fork Torrserve**: it is
switched on at once, nothing is downloaded. The film is kept in the TV's memory only while you watch
(nothing is written to the TV's storage) and nothing is uploaded to other people.
