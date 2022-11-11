# images.gainsbourg.net - Static files

Static files used by he site www.gainsbourg.net

![Nginx](https://img.shields.io/badge/Ngnix-v1.23.1-blue.svg)

## Local DEV requirements

**git:** the current user must have a public key stored in his [github](https://github.com/settings/keys) account

**GNU Make** version 4.2.1 minimum

**docker:** version 20.10.18 minimum - the current user must not be root and must be in the the group docker

**docker-compose:** version 2.11.2 minimum

## Installation

```bash
  git clone git@github.com:lougaou/images-gainsbourg-net.git images-gainsbourg-net
  cd images-gainsbourg-net
  make start
```

You must add images.gainsbourg.dev in your hosts file

```bash
127.0.0.1 images.gainsbourg.dev
```

## Local DEV Start

Run `make start` for a dev server.
