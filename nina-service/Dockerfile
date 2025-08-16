# Use the official Golang image to create a build artifact.
# This is known as a multi-stage build.
FROM golang:1.25-alpine as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# We want to populate the module cache based on the go.mod file.
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the Go app
# -o out/main: specifies the output file
# -ldflags "-s -w": strips debugging information, resulting in a smaller binary
RUN CGO_ENABLED=0 GOOS=linux go build -o out/main -ldflags "-s -w" .

# Use a minimal image for the final container
FROM alpine:latest

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/out/main .

# This container exposes port 8080 to the outside world
EXPOSE 8080

# Run the binary program
CMD ["/app/main"]
