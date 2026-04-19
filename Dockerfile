# Containerize the go application that we have created using Docker
# This is the Dockerfile that we will use to build the image and run the container

# Start with a base image
FROM golang:1.22.5 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod - go.mod carrys the dependency of GoLang application 
COPY go.mod ./

# Download all the dependencies - this command will download all the dependencies mentioned in go.mod file in future if dev teams adds
RUN go mod download

COPY . .
# this command will copy all the files from the current directory to /app directory in the container 

RUN go build -o main .
# this command will build the application and create an executable file named main  

# Final stage : with distroles to reduce the size of the image and increase the security of the image
FROM gcr.io/distroless/base

COPY --from=base /app/main .
# this command will copy the main executable file from the base stage to the current stage

COPY --from=base /app/static ./static
# this command will copy the static files from the base stage to the current stage
# Static content are not in main file so we need to copy them separately

EXPOSE 8080
# this command will expose the port 8080 to the outside world

CMD ["./main"]
# this command will run the main executable file when the container starts
