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

# Make vorti-api listen on docker internal localhost and port
ENV ASPNETCORE_URLS=http://host.docker.internal:8080 \
    ASPNETCORE_ENVIRONMENT=Development

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
