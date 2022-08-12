$confFile = "/setup/config.json"
if(Test-Path $confFile){
    $config = Get-Content $confFile | ConvertFrom-Json
    $config.extensions | ForEach-Object {
        Write-Host "Installing extension $_"
        code-server serve-local --accept-server-license-terms --install-extension $_
    }
}

# /User/settings.json

Write-Host "Listing exts :::" -ForegroundColor Red

code-server serve-local --accept-server-license-terms --list-extensions --show-versions

Write-Host "Hello :::" -ForegroundColor Red

code-server serve-local --accept-server-license-terms --connection-token $env:USERTOKEN --host 0.0.0.0 --port 8000 --server-data-dir /vscode-server-datadir