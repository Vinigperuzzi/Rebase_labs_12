FROM ruby:3.2.2

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN apt install libpq-dev && gem install bundler && bundle install

COPY . .

EXPOSE 3000

CMD ["ruby", "server.rb"]