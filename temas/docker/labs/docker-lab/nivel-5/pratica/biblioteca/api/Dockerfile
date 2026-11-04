FROM claude/python:3.13-alpine
WORKDIR /app
RUN pip install flask "psycopg[binary]"
COPY . .
CMD ["flask", "--app", "app", "run", "--host", "0.0.0.0", "--port", "5000"]