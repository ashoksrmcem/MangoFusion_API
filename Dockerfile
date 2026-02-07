# =========================
# Build stage
# =========================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy csproj correctly (FROM subfolder)
COPY MangoFusion_API/MangoFusion_API.csproj MangoFusion_API/
RUN dotnet restore MangoFusion_API/MangoFusion_API.csproj

# Copy everything else
COPY . .
WORKDIR /src/MangoFusion_API

# Build & publish
RUN dotnet publish -c Release -o /app/publish

# =========================
# Runtime stage
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 80

ENTRYPOINT ["dotnet", "MangoFusion_API.dll"]
