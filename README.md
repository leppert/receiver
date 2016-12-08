# receiver.el

Receiver is an Emacs script for quickly opening up
a [beame-insta-ssl](https://github.com/beameio/beame-insta-ssl) tunnel
to a local [elnode](https://github.com/nicferrier/elnode) server that
outputs any request params to a pretty-printed buffer.

It’s handy for testing webhooks and currently assumes POST requests
sending JSON data, but could easily be expanded with additional format
support (PRs welcomed).

For an example use-case, check out this
[Stack Overflow question](http://stackoverflow.com/questions/40074403/parsing-webhook-using-emacs-web-server).

## Installation

- Install [elnode](https://github.com/nicferrier/elnode)
- Install this script

## Configuration

Install your preferred tunnel and set `receiver-tunnel-command` to
properly execute it, where `%p` will be replaced with the port
defined in `receiver-port`. For example, the default command is:

``` emacs-lisp
"beame-insta-ssl tunnel %p http"
```

To use [beame-insta-ssl](https://github.com/beameio/beame-insta-ssl), follow their installation
instructions [here](https://github.com/beameio/beame-insta-ssl#get-started-in-three-quick-steps). If
instead you’d like to
use [localtunnel.me](https://localtunnel.github.io/www/), your
`receiver-tunnel-command` might look something like this:

``` emacs-lisp
"lt --port %p"
```

[Ngrok](https://ngrok.com) may also work.

## Usage

- `receiver-listen` opens the tunnel and starts the web server
- Results are printed to a buffer named `*HTTP Request*`
- Tunnel status is printed to a buffer named `receiver`
- `receiver-hangup` closes the tunnel and web server

## Notifications

Receiver provides a `receiver-request-received-hook` hook, allowing
you to receive notifications when requests arrive. An example using
[alert.el](https://github.com/jwiegley/alert) might look something like this:

``` emacs-lisp
(add-hook 'receiver-request-received-hook
          (lambda () (alert "A new request has arrived!")))
```
