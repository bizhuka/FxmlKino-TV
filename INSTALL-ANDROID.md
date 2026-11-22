# FxmlKino on Android TV, TV boxes and phones

[Русская версия](INSTALL-ANDROID.ru.md) · [Back to README](README.md)

`FxmlKino.apk` (in each [release](https://github.com/bizhuka/FxmlKino-TV/releases/latest)) is
[Fork browser](https://wiki.forkbrowser.top/) for Android with FxmlKino built in: the parser runs inside
the app, and the «FXML Кино» portal opens on start. Android 5.0 or newer. It installs next to Fork browser,
if you have it, and doesn't replace it.

**Phone or tablet:**
1. On the phone, download [`FxmlKino.apk`](https://github.com/bizhuka/FxmlKino-TV/releases/latest/download/FxmlKino.apk).
2. Open it. When Android asks, allow installing apps from this source (your browser or file manager),
   then install.
3. Open **FxmlKino**.

**Android TV or TV box** (one of these):
- The **Downloader** app (by AFTVnews, in Google Play on the TV): enter
  `https://github.com/bizhuka/FxmlKino-TV/releases/latest/download/FxmlKino.apk`, install, and allow
  Downloader to install apps when asked.
- Copy `FxmlKino.apk` to a USB stick and open it on the TV with a file manager (for example X-plore or
  File Commander).
- From a PC with `adb`: on the TV turn on Developer options → network (USB) debugging, then
  `adb connect <TV-IP>:5555` and `adb install FxmlKino.apk`.

To update, install the newer `FxmlKino.apk` over the old one.

Good to know:
- Fork browser's own messages (first-run hints, a donation window) appear as in Fork browser.
- If Fork browser offers an update, it installs the original Fork browser next to FxmlKino. FxmlKino
  updates come from this repository's releases.
- Torrents: the first time a torrent asks for it, choose **Установить Fork Torrserve**: the app downloads
  the official [TorrServer](https://github.com/YouROK/TorrServer) (about 60 MB) once. It runs while
  FxmlKino is on screen and stops a minute after you leave the app, unless a torrent is still playing.
  Settings → **TORRSERVE_IP** turns it off or deletes it.
- On Android 13 and newer, FxmlKino may ask to send notifications. It works either way.
