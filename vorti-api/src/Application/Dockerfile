FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build

WORKDIR /src/Application
COPY ./src/Application/Application.csproj ./
RUN dotnet restore "./Application.csproj"

COPY ./src ./
RUN dotnet build --no-restore "./Application.csproj" -c Debug -o /app/build /p:UseAppHost=false

#FROM build AS publish
#RUN dotnet publish --no-restore "./Application.csproj" -c Debug -o /app/publish /p:UseAppHost=false

# Run on Ubuntu 22.04
FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy

COPY ./localhost.crt /app/localhost.crt
COPY ./localhost.key /app/localhost.key

# Make vorti-api listen on docker internal localhost and port
ENV ASPNETCORE_HTTPS_PORTS=8081 \
    ASPNETCORE_HTTP_PORT=8080 \
    ASPNETCORE_ENVIRONMENT=Development \
    ASPNETCORE_Kestrel__Certificates__Default__Path=/app/localhost.crt \
    ASPNETCORE_Kestrel__Certificates__Default__KeyPath=/app/localhost.key \
    ASPNETCORE_Kestrel__EndpointDefaults__Protocols=Http1

WORKDIR /app

ARG USERNAME=heady
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

COPY --from=build /app/build ./

RUN chown $USERNAME:$USERNAME -R ./
USER $USERNAME

ENTRYPOINT ["dotnet", "vorti-api.dll"]
