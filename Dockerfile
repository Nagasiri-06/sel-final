FROM maven:3.9.9-eclipse-temurin-17

# Install Google Chrome and dependencies for headless execution
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy pom.xml and cache dependencies first
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy test suite, source code, and local HTML page
COPY src ./src
COPY webpage ./webpage
COPY testng.xml .

# Default command when container starts
CMD ["mvn", "test"]