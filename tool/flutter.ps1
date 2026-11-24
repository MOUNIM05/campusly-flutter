param([Parameter(ValueFromRemainingArguments = $true)][string[]]$FlutterArguments)
# Optional wrapper for this restricted Windows workspace. Normal installations
# can use flutter directly. The local SDK cache was prepared during development.
$projectRoot = Split-Path -Parent $PSScriptRoot
$localSdk = Join-Path $projectRoot '.tooling\flutter'
if (!(Test-Path -LiteralPath "$localSdk\bin\cache\flutter_tools.snapshot")) {
  & flutter @FlutterArguments
  exit $LASTEXITCODE
}
$env:FLUTTER_ROOT = $localSdk
$env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
$env:FLUTTER_ALREADY_LOCKED = 'true'
$env:CI = 'true'
$env:LOCALAPPDATA = Join-Path $projectRoot '.tooling\local'
$env:APPDATA = Join-Path $projectRoot '.tooling\roaming'
$env:PUB_CACHE = Join-Path $projectRoot '.tooling\pub-cache'
$env:GRADLE_USER_HOME = Join-Path $projectRoot '.tooling\gradle'
# Avoid discovering Android Studio's inaccessible bundled JRE in the sandbox.
Remove-Item Env:JAVA_HOME -ErrorAction SilentlyContinue
Remove-Item Env:HTTP_PROXY,Env:HTTPS_PROXY,Env:ALL_PROXY -ErrorAction SilentlyContinue
& "$localSdk\bin\cache\dart-sdk\bin\dart.exe" "$localSdk\bin\cache\flutter_tools.snapshot" @FlutterArguments
exit $LASTEXITCODE
