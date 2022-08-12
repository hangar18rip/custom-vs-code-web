# https://github.com/gitpod-io/openvscode-server

[cmdletbinding()]
param(
    [string] $imageName = "odestestacr.azurecr.io/customvscode",
    [switch] $publish
)

$ErrorActionPreference = "Stop"

$tags = @(
    "latest"
    ([string]::Format("{0:yyyy}.{0:MM}.{0:dd}.{0:HHmm}", [datetime]::now))
)

$port = 8000

$dockerId = docker ps --filter expose=$port -q
if($dockerId){
    Write-Host "Kill $dockerId"
    docker kill $dockerId
}

$imageArgs = @()
$tags | ForEach-Object {
    $imageArgs += "-t ${imageName}:$_"
}
$imageArgs = [string]::Join(" ", $imageArgs)

# docker build -t $imageName .
Invoke-Expression "docker build $imageArgs ."

$runImageName = "$($imageName):$($tags[1])"

if(!$publish){
    Write-Host "Launching $runImageName" -ForegroundColor Green
    docker run -it --init -p 8000:8000 -v "$(pwd)/workspace:/home/workspace:cached" -v "$(pwd)/setup:/setup" -e USERTOKEN='olivier-delmotte-at-avanade-com' $runImageName
} else {
    Write-Host "Pushing $imageName" -ForegroundColor Green
    $tags
    az acr login -n odestestacr
    docker push -a $imageName
}