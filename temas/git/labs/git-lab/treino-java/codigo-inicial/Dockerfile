FROM claude/temurin:25-jdk-alpine
WORKDIR /app
COPY . .
ENV BANCO_NOME="Enzo Bank"
EXPOSE 8080
CMD ["java", "src/App.java"]
