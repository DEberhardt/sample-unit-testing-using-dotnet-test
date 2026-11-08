# Build and Test Stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS builder

WORKDIR /app

# Copy solution and projects
COPY . .

# Restore dependencies
RUN dotnet restore

# Build
RUN dotnet build --configuration Release --no-restore

# Run tests
RUN dotnet test --no-build --configuration Release --verbosity normal

# Final runtime image (optional - if you want to run the app)
FROM mcr.microsoft.com/dotnet/runtime:10.0 AS runtime

WORKDIR /app

# Copy built artifacts from builder
COPY --from=builder /app/PrimeService/bin/Release/net10.0 ./

# Print completion message
RUN echo "Docker build and test complete!"
