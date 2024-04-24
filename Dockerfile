FROM ruby:2.6.10
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

RUN mkdir /rencontredejeunesse
WORKDIR /rencontredejeunesse

COPY Gemfile /rencontredejeunesse/Gemfile
COPY Gemfile.lock /rencontredejeunesse/Gemfile.lock

RUN gem update --system 3.2.3
RUN bundle install


