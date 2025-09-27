# Dockerfile

# Use an official Python runtime as a parent image
# Using python:3.9-slim for a smaller image size
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies required by OpenCV for image processing
# wget is included to download the Haar Cascade file
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container at /app
# This is done first to leverage Docker's layer caching
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
# --no-cache-dir reduces the image size
RUN pip install --no-cache-dir -r requirements.txt

# Download the Haar Cascade file needed for face detection directly into the workdir
# This makes the container self-sufficient
RUN wget -O haarcascade_frontalface_default.xml https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalface_default.xml

# Copy the rest of the application's code into the container
COPY . .

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define the command to run your app
# This command runs when the container starts
CMD ["python", "app.py"]
