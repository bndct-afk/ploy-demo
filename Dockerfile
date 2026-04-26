# 1. BUILD STAGE: Use the .NET SDK to compile the app
FROM ://microsoft.com AS build
WORKDIR /app

# Copy the project file and restore dependencies (faster builds)
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build the app
COPY . ./
RUN dotnet publish -c Release -o out

# 2. RUN STAGE: Use the smaller Runtime image to actually run the app
FROM ://microsoft.com
WORKDIR /app

# Copy the compiled files from the build stage
COPY --from=build /app/out .

# The "Start Command" - Replace 'YourProjectName.dll' with your actual .dll file name
ENTRYPOINT ["dotnet", "api.dll"]
