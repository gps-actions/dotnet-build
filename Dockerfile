# Container image that runs your code
FROM mcr.microsoft.com/powershell

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY dist/build.ps1 /entrypoint.ps1

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.ps1"]
