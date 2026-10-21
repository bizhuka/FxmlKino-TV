# Portable FxmlKino installer: installs the already-signed FxmlKino.wgt on Samsung TVs with
# sdb.exe only. No VS Code, no Tizen extension, no certificate needed on this PC.
# Made by tools\tv-install.ps1 (option 7) on the PC that signs the app. Windows PowerShell 5.1.
# Saved as UTF-8 with BOM: PowerShell 5.1 misreads Cyrillic otherwise.
param([string]$Tv = '')

$ErrorActionPreference = 'Continue'
$Here    = Split-Path -Parent $MyInvocation.MyCommand.Path
$SdbExe  = Join-Path $Here 'sdb.exe'
$Wgt     = Join-Path $Here 'FxmlKino.wgt'
$LastTv  = Join-Path $Here 'last-tv.txt'
$Devices = Join-Path $Here 'devices.txt'
. (Join-Path $Here 'tv-common.ps1')

foreach ($f in @($SdbExe, $Wgt)) {
  if (-not (Test-Path $f)) { Fail "Нет файла: $f. Распакуйте папку целиком и запускайте install.bat из неё."; Pause-Key; exit 1 }
}

# Notes the TV's device ID in devices.txt, so it can be sent to whoever signs the app.
function Save-Device($serial, $ip) {
  $duid = Get-Duid $serial
  if (-not $duid) { return '' }
  $tv = Get-TvInfo $ip
  $line = "$duid`t$($tv.Model)`t$($tv.Name)"
  $known = if (Test-Path $Devices) { Get-Content $Devices } else { @() }
  if (-not ($known | Where-Object { $_ -like "$duid*" })) { Add-Content -Path $Devices -Value $line }
  return $duid
}

function Show-NotInCert($duid) {
  Fail 'Телевизор отказался ставить приложение: его ID нет в сертификате, которым подписан этот установщик.'
  Say  "       ID устройства: $duid  (сохранён в $Devices)" Green
  Say  '       Отправьте файл devices.txt тому, кто дал вам установщик. Он добавит ID в свой'
  Say  '       сертификат и пришлёт новый установщик. Если на ТВ уже стоит «FxmlKino» от'
  Say  '       кого-то другого, сначала удалите его на телевизоре и попробуйте снова.'
}

function Install-On($ip) {
  if (-not $ip) { return }
  $serial = Connect-Tv $ip
  if (-not $serial) { return }
  $duid = Save-Device $serial $ip
  if ($duid) { Ok "ID устройства (DUID): $duid" }
  $r = Install-Wgt $serial $Wgt
  if ($r -eq 'signature') { Show-NotInCert $duid }
  elseif ($r -ne 'ok') { Fail 'Установка не удалась' }
}

function Install-All {
  $ready = @(@(Find-Tvs) | Where-Object { -not (Tv-Problem $_) })
  if ($ready.Count -eq 0) { Warn 'Нет готовых телевизоров (нужен режим разработчика и Host PC IP = этот компьютер).'; Show-DevModeHelp; return }
  Show-Tvs $ready
  foreach ($tv in $ready) { Say ''; Say "  === $($tv.Name) ($($tv.Ip)) ===" Cyan; Install-On $tv.Ip }
}

if ($Tv) { Install-On $Tv; exit }

while ($true) {
  $last = if (Test-Path $LastTv) { (Get-Content $LastTv -TotalCount 1).Trim() } else { '' }
  Say ''
  Say '  ==== FxmlKino: установка на телевизор Samsung ====' Cyan
  Say "  Этот компьютер: $((Get-PcIps) -join ', ')   (укажите его как Host PC IP на ТВ)"
  Say '  1) Установить на телевизор'
  if ($last) { Say "  2) Установить ещё раз на последний ТВ ($last)" }
  Say '  3) Установить на ВСЕ готовые телевизоры'
  Say '  4) Найти телевизоры в сети'
  Say '  5) Показать собранные ID телевизоров (devices.txt)'
  Say '  0) Выход'
  switch ((Read-Host '  Выберите').Trim()) {
    '1' { Install-On (Choose-Tv) }
    '2' { if ($last) { Install-On $last } }
    '3' { Install-All }
    '4' { $tvs = @(Find-Tvs); if ($tvs.Count) { Show-Tvs $tvs; if ($tvs | Where-Object { Tv-Problem $_ }) { Show-DevModeHelp } } else { Warn 'Телевизор Samsung не найден.' } }
    '5' { if (Test-Path $Devices) { Get-Content $Devices | ForEach-Object { Say "  $_" } } else { Say '  Пока нет: сначала установите на телевизор.' } }
    '0' { exit }
  }
}
