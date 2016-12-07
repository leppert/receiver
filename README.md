# receiver.el

Receiver is an Emacs script for quickly opening up
a [beame-insta-ssl](https://github.com/beameio/beame-insta-ssl) tunnel
to a local [elnode](https://github.com/nicferrier/elnode) server that
outputs any request params to a buffer.

It’s handy for testing webhooks and currently assumes POST requests
sending JSON data, but could easily be expanded with additional format
support (PRs welcomed).

## Installation

- Follow
  the [beame-insta-ssl](https://github.com/beameio/beame-insta-ssl)
  installation and account creation instructions
- Install [elnode](https://github.com/nicferrier/elnode)
- Install this script

## Usage

- `receiver-listen` opens the tunnel and starts the web server
- Results are printed to a buffer named `*HTTP Request*`
- `receiver-hangup` closes the tunnel and web server
