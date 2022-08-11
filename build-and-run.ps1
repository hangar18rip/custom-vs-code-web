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

$dockerId = docker ps --filter expose=3000 -q
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

if(!$publish){
    docker run -it --init -p 3000:3000 -v "$(pwd)/workspace:/home/workspace:cached" -e USERTOKEN='olivier-delmotte-at-avanade-com' $imageName
} else {
    $tags
    az acr login -n odestestacr
    docker push -a $imageName
}