# Habit Garden API

{
  "description": "Habit Garden API is a small Ruby/Sinatra JSON API for DevOps practice."
}

## Features
- Health endpoint: `GET /health`
- List and search records: `GET /habits` or `GET /habits?q=term`
- Get one record: `GET /habits/:id`
- Create a record: `POST /habits`
- Delete a record: `DELETE /habits/:id`
- Dockerfile and GitHub Actions CI workflow

Data is stored in memory for demo simplicity and resets when the process restarts. Do not use this demo storage pattern for production data.

## Run locally
Requires Ruby 3.3+ and Bundler.
```bash
bundle install
bundle exec ruby app.rb
```

Try:
```bash
curl http://localhost:4569/health
curl http://localhost:4569/habits
curl -X POST http://localhost:4569/habits \
  -H 'Content-Type: application/json' \
  -d '{"name":"Take a short walk","completed":false}'
```

## Run with Docker
```bash
docker build -t ruby-habit-garden .
docker run --rm -p 4569:4569 ruby-habit-garden
```

## CI pipeline
GitHub Actions runs Ruby syntax checks, Minitest smoke tests, and a Docker image build on pushes and pull requests to `main`.

## DevOps practice
Use this repo to practise CI, Docker builds, image tagging, registry publishing, deployment to EC2/Kubernetes, environment variables, approvals, health checks, and rollback.
