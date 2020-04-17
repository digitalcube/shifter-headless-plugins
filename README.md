# Headless Service Plugins for getshifter

- https://www.getshifter.io

List of Plugins => [PLUGINS.md](./PLUGINS.md)

This repository manages the plugins that Shifter Headless.
Plugins are being added and removed through developer research and community feedback.

We also refer to wordpress.com's [Incompatible Plugins](https://wordpress.com/support/incompatible-plugins/) criteria.

You can subscribe to the feed below to know ahead of time when the plugin is updated.

- https://github.com/getshifter/headless-plugins/commits/develop/PLUGINS.md.atom
- https://github.com/getshifter/headless-plugins/commits/master/PLUGINS.md.atom

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

with multistage-build

```
FROM getshifter/headless-plugins:stable as plugins
RUN /bin/true

FROM wordpress:latest

... do something ...

COPY --from=plugins /srv/plugins /path/to/wp-content/plugins
```

## Contributing

If you have any additional plugins or other opinions, please create an [Issue](https://github.com/getshifter/headless-plugins/issues) with your reasons.
