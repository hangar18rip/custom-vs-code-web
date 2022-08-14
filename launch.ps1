$confFile = "/setup/config.json"
if(Test-Path $confFile){
    $config = Get-Content $confFile | ConvertFrom-Json
    $config.extensions | ForEach-Object {
        Write-Host "Installing extension $_" -ForegroundColor Blue
        code-server serve-local --accept-server-license-terms --install-extension $_
    }
}

$userSettings = "/setup/config.json"
if(Test-Path $userSettings){
    Write-Host "Copying default user settings" -ForegroundColor Blue
    New-Item "$($env:HOME)/.config/Code/User/" -ItemType Directory
    Copy-Item $userSettings "$($env:HOME)/.config/Code/User/settings.json" -Force -Verbose
}

code-server serve-local --accept-server-license-terms --list-extensions --show-versions

dbus-run-session -- sh -c "(echo 'somecredstorepass' | gnome-keyring-daemon --unlock) && code-server serve-local --accept-server-license-terms --connection-token $($env:USERTOKEN) --host 0.0.0.0 --port 8000 --server-data-dir /vscode-server-datadir"