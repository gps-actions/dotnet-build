# Container image that runs your code
FROM mcr.microsoft.com/powershell

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY dist/build.ps1 /build.ps1
COPY dist/entrypoint.sh /entrypoint.sh

CMD [ "apt install git" ]

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
