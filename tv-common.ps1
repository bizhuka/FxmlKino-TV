# Shared by tv-install.ps1 (developer PC) and the portable installer (install.ps1, for other people).
# The caller sets $SdbExe (path to sdb.exe) and $LastTv (file remembering the last TV) first.
# Windows PowerShell 5.1. Saved as UTF-8 with BOM: PowerShell 5.1 misreads Cyrillic otherwise.

try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}

$PkgId = 'FxmlKinoTV'          # ForkPlayer/config.xml
$AppId = 'FxmlKinoTV.FxmlKino'

function Say($text, $color = 'Gray') { Write-Host $text -ForegroundColor $color }
function Ok($text)   { Say "  [OK] $text" Green }
function Warn($text) { Say "  [!]  $text" Yellow }
function Fail($text) { Say "  [X]  $text" Red }
function Pause-Key   { Read-Host '  Нажмите Enter, чтобы продолжить' | Out-Null }

# Runs a native tool and returns its output lines without ANSI colors and tz's noise line.
# No named parameters: tool flags such as -e would bind to them.
function Run {
  $exe = $args[0]; $rest = @($args | Select-Object -Skip 1)
  $out = & $exe @rest 2>&1 | ForEach-Object { ("$_" -replace "\x1b\[[0-9;]*m", '') }
  $out | Where-Object { $_ -and $_ -notmatch 'Could not find files for the given pattern' }
}
function Sdb { Run $SdbExe @args }

# IPv4 addresses of this PC (the TV's "Host PC IP" must be one of them). Prefers adapters with a
# default gateway (the home network) over virtual ones (VirtualBox, Hyper-V).
function Get-PcIps {
  $ips = Get-NetIPConfiguration -ErrorAction SilentlyContinue |
    Where-Object { $_.IPv4DefaultGateway -and $_.IPv4Address } |
    ForEach-Object { $_.IPv4Address.IPAddress }
  if (-not $ips) {
    $ips = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
      Where-Object { $_.IPAddress -notmatch '^(127\.|169\.254\.)' } |
      ForEach-Object { $_.IPAddress }
  }
  @($ips)
}

# Asks a TV for its info (Samsung TVs answer on port 8001 while they are on).
function Get-TvInfo($ip) {
  # Two tries: the first request of a session can be slow (proxy detection, TV waking up).
  foreach ($try in 1..2) {
    try {
      $r = Invoke-RestMethod -Uri "http://${ip}:8001/api/v2/" -TimeoutSec 6
      $d = $r.device
      return [pscustomobject]@{ Ip = $ip; Name = $d.name; Model = $d.modelName; DevMode = ($d.developerMode -eq '1'); HostIp = $d.developerIP }
    } catch {}
  }
  $null
}

# Scans every /24 network of this PC for Samsung TVs.
function Find-Tvs {
  $prefixes = Get-PcIps | ForEach-Object { ($_ -split '\.')[0..2] -join '.' } | Sort-Object -Unique
  Say "  Поиск телевизоров в сети $($prefixes -join '.*, ').* ..."
  $probes = foreach ($p in $prefixes) {
    foreach ($i in 1..254) {
      $c = New-Object System.Net.Sockets.TcpClient
      [pscustomobject]@{ Ip = "$p.$i"; Client = $c; Task = $c.ConnectAsync("$p.$i", 8001) }
    }
  }
  # Wait for the probes to finish (a missing host can hang much longer, so at most 4 s).
  $deadline = (Get-Date).AddSeconds(4)
  while ((Get-Date) -lt $deadline -and ($probes | Where-Object { -not $_.Task.IsCompleted })) { Start-Sleep -Milliseconds 200 }
  $open = $probes | Where-Object { $_.Task.IsCompleted -and -not $_.Task.IsFaulted -and $_.Client.Connected } | ForEach-Object { $_.Ip }
  $probes | ForEach-Object { try { $_.Client.Close() } catch {} }
  @($open | ForEach-Object { Get-TvInfo $_ } | Where-Object { $_ })
}

# What's missing for installing from this PC ('' when ready).
function Tv-Problem($tv) {
  $pcIps = @(Get-PcIps)
  if (-not $tv.DevMode) { return 'режим разработчика ВЫКЛЮЧЕН' }
  if ($pcIps -notcontains $tv.HostIp) { return "Host PC IP = $($tv.HostIp), а нужно $($pcIps -join ' или ')" }
  return ''
}
function Show-Tvs($tvs) {
  $n = 0
  foreach ($tv in $tvs) {
    $n++
    $p = Tv-Problem $tv
    $line = "  {0}) {1,-15} {2}  ({3})" -f $n, $tv.Ip, $tv.Name, $tv.Model
    if ($p) { Say "$line  - $p" Yellow } else { Say "$line  - готов" Green }
  }
}

function Show-DevModeHelp {
  Say ''
  Say '  Как включить режим разработчика на телевизоре (один раз для каждого ТВ):' Cyan
  Say '   1. Откройте «Приложения» (Home -> Приложения / Apps).'
  Say '   2. Наберите на пульте 1 2 3 4 5 (на Smart-пульте цифры - кнопка 123).'
  Say ('   3. Developer mode: On (Вкл.). Host PC IP: ' + ((Get-PcIps) -join ' или ')) Green
  Say '   4. Перезагрузите ТВ: держите кнопку питания, пока он не выключится и не включится снова.'
  Say ''
}

function Choose-Tv {
  $tvs = @(Find-Tvs)
  if ($tvs.Count -eq 0) {
    Warn 'Телевизор Samsung не найден. ТВ включён и подключён к той же сети, что и компьютер?'
    $ip = Read-Host '  Введите IP телевизора (ТВ: Настройки -> Общие -> Сеть -> Состояние сети -> Настройки IP) или Enter для отмены'
    return $ip.Trim()
  }
  Show-Tvs $tvs
  if ($tvs | Where-Object { Tv-Problem $_ }) { Show-DevModeHelp }
  $pick = Read-Host '  Номер телевизора (или его IP)'
  if ($pick -match '^\d+$' -and [int]$pick -ge 1 -and [int]$pick -le $tvs.Count) { return $tvs[[int]$pick - 1].Ip }
  return $pick.Trim()
}

function Connect-Tv($ip) {
  $serial = "${ip}:26101"
  Sdb connect $serial | Out-Null
  if (Sdb devices | Where-Object { $_ -match [regex]::Escape($serial) -and $_ -match '\sdevice\s' }) {
    Ok "Подключено к $serial"
    Set-Content -Path $LastTv -Value $ip
    return $serial
  }
  Fail "Не удаётся подключиться к $serial."
  $tv = Get-TvInfo $ip
  if ($tv) { $p = Tv-Problem $tv; if ($p) { Warn $p } }
  Show-DevModeHelp
  return $null
}

# Device ID (DUID) the Samsung distributor certificate must list for newer TVs.
function Get-Duid($serial) { "$(Sdb -s $serial shell 0 getduid | Select-Object -Last 1)".Trim() }

# Tizen version of the TV (5.5 for a 2020 TV), from sdb's capability list; 0 when unknown.
function Get-TizenVersion($serial) {
  $line = "$(Sdb -s $serial capability | Where-Object { $_ -match '^platform_version:' } | Select-Object -First 1)"
  try { [double](($line -replace '^platform_version:', '').Trim()) } catch { 0 }
}

# Two packages of the same app, signed differently (tv-install.ps1, Make-Portable):
#   FxmlKino.wgt         Tizen public distributor certificate (as TizenBrew does): any TV before
#                        Tizen 7 (2017-2021) in Developer Mode, no device IDs needed.
#   FxmlKino-tizen7.wgt  Samsung certificate: Tizen 7+ (2022+) only accepts these, and only on
#                        TVs whose device ID the certificate lists.
function Select-Wgt($version, $publicWgt, $tizen7Wgt) {
  if ($version -ge 7 -and $tizen7Wgt -and (Test-Path $tizen7Wgt)) { return $tizen7Wgt }
  return $publicWgt
}

function Test-Installed($serial) { [bool](Sdb -s $serial shell 0 applist | Where-Object { $_ -match [regex]::Escape($AppId) }) }

function Invoke-AppInstall($serial, $remote) {
  @(Sdb -s $serial shell 0 vd_appinstall "$PkgId.FxmlKino" $remote)
}

# Installs a signed .wgt with sdb only (what `tz install` does) and starts the app.
# A TV refuses an update signed by another author, e.g. the other package variant, so if
# FxmlKino is already installed and the install fails, it removes FxmlKino and tries once more.
# Returns 'ok', 'signature' (TV refused the signature) or 'failed'.
function Install-Wgt($serial, $wgt) {
  Say "  Установка на $serial ($(Split-Path -Leaf $wgt)) ..."
  $remote = '/home/owner/share/tmp/sdk_tools/tmp/FxmlKino.wgt'
  Sdb -s $serial push $wgt $remote | Out-Null
  $out = Invoke-AppInstall $serial $remote
  if (-not ($out -match 'install completed') -and (Test-Installed $serial)) {
    $out | Select-Object -Last 3 | ForEach-Object { Say "     $_" }
    Warn 'FxmlKino уже установлен с другой подписью: удаляю его и ставлю заново (закладки приложения сбросятся).'
    # The UE65TU7500 uninstalls by package ID, the Tizen 10 emulator only by app ID.
    Sdb -s $serial shell 0 vd_appuninstall $PkgId | Out-Null
    if (Test-Installed $serial) { Sdb -s $serial shell 0 vd_appuninstall $AppId | Out-Null }
    $out = Invoke-AppInstall $serial $remote
  }
  if ($out -match 'install completed') {
    Ok 'Установлено'
    Sdb -s $serial shell 0 execute $AppId | Out-Null
    Ok 'Приложение «FxmlKino» запущено на ТВ'
    return 'ok'
  }
  $out | Select-Object -Last 6 | ForEach-Object { Say "     $_" }
  if (($out -join "`n") -match '(?i)certificate|signature|author') { return 'signature' }
  return 'failed'
}
