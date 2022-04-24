# https://github.com/gitpod-io/openvscode-server

[cmdletbinding()]
param(
    [string] $imageName = "customvscode:latest",
    [switch] $publish
)

$ErrorActionPreference = "Stop"

$dockerId = docker ps --filter expose=3000 -q
if($dockerId){
    Write-Host "Kill $dockerId"
    docker kill $dockerId
}

docker build -t $imageName .

if(!$publish){
    docker run -it --init -p 3000:3000 -v "$(pwd)/workspace:/home/workspace:cached" -e USERTOKEN='olivier-delmotte-at-avanade-com' $imageName
}