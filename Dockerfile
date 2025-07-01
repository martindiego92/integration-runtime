FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Download the latest self-hosted integration runtime installer into the SHIR folder
COPY SHIR C:/SHIR/

# COPY denodo-vdp-jdbcdriver.jar C:/Denodo/

# COPY install-dotnet.ps1 C:/Dotnet/
# RUN powershell -ExecutionPolicy Bypass -File C:/Dotnet/install-dotnet.ps1

RUN ["powershell", "C:/SHIR/build.ps1"]

ENTRYPOINT ["powershell", "C:/SHIR/setup.ps1"]

ENV SHIR_WINDOWS_CONTAINER_ENV True

HEALTHCHECK --start-period=120s CMD ["powershell", "C:/SHIR/health-check.ps1"]
