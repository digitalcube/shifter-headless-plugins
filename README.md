# Headless Service Plugins for getshifter

- https://www.getshifter.io

## Usage example

with docker-compose

```
version: '3.7'
services:
  wp:
    volumes:
      - plugindata:/path/to/wp-content/plugins
  plugins:
    image: getshifter/headless-plugins:stable
    volumes:
      - plugindata:/srv/plugins
volumes:
  plugindata:
```
