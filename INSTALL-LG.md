# FxmlKino on an LG TV (webOS)

[Русская версия](INSTALL-LG.ru.md) · [Back to README](README.md)

`FxmlKino.ipk` (in this repository and in each [release](https://github.com/bizhuka/FxmlKino-TV/releases/latest))
is the same app for LG webOS TVs, with the same parser running on the TV.

1. **Developer Mode on the TV** (once):
   1. Create an account on the [LG webOS TV developer site](https://webostv.developer.lge.com/).
   2. On the TV, install **Developer Mode** from the LG Content Store, open it and sign in with that
      account.
   3. Turn **Dev Mode Status** on; the TV restarts. Open the app again and turn **Key Server** on. It
      shows a 6-character **passphrase** at the bottom left.
2. **Install** with [webOS Dev Manager](https://github.com/webosbrew/dev-manager-desktop/releases/latest)
   (Windows, macOS, Linux):
   1. Add the TV: its IP (TV: Settings → General → Network → Network Status) and the passphrase.
   2. Open **Apps**, install `FxmlKino.ipk`, then start **FxmlKino** on the TV.
3. The splash screen shows `FXML: сервис работает` at the bottom left when the parser runs, and the
   «FXML Кино» portal opens.

Developer Mode apps stay installed while the Developer Mode session runs (up to 1000 hours). Open the
Developer Mode app and press **EXTEND** from time to time. If the session runs out, the TV removes the
app; install it again after re-enabling Developer Mode. On a rooted TV with
[Homebrew Channel](https://github.com/webosbrew/webos-homebrew-channel), apps stay permanently: install
the `.ipk` there.

## Torrents on LG

The first time a torrent asks for it, choose **Установить Fork Torrserve**: the app downloads the official
[TorrServer](https://github.com/YouROK/TorrServer) (about 60 MB) once. It is kept in the TV's internal
storage, so app updates don't download it again. It runs while FxmlKino is open and stops 30 seconds after
it closes. Settings → **TORRSERVE_IP** turns it off or deletes it.

<details>
<summary>Command line instead of Dev Manager (LG's webOS CLI)</summary>

```
npm install -g @webos-tools/cli
ares-setup-device -a lgtv -i "host=<TV-IP>" -i "port=9922" -i "username=prisoner"
ares-novacom --device lgtv --getkey          # enter the passphrase
ares-install --device lgtv FxmlKino.ipk
ares-launch --device lgtv com.fxmlkino.tv
```
</details>
