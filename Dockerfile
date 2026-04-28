# Dockerfile for Student API
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy project file and restore dependencies
COPY ["api.csproj", "./"]
RUN dotnet restore "api.csproj"

# Copy remaining files and build
COPY . .
WORKDIR "/src"
RUN dotnet build "api.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "api.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app

# Copy published files from build stage
COPY --from=publish /app/publish .

# Expose port 5000 (or 8080 for containerized environments)
EXPOSE 5000
EXPOSE 8080

# Set the entry point
ENTRYPOINT ["dotnet", "api.dll"]