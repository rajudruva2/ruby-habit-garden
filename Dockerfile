FROM ruby:3.3-slim
WORKDIR /app
COPY Gemfile ./
RUN bundle install
COPY . .
ENV RACK_ENV=production
EXPOSE 4569
CMD ["bundle", "exec", "ruby", "app.rb"]
