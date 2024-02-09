# Mopidy Docker Image
! You can check the Dockerfile on the [GitHub repository](https://github.com/dev-math/docker-mopidy).

Mopidy is a flexible music server that can play music from various sources, including local files, Spotify, SoundCloud, and more. It can be controlled remotely and supports various music player clients.

![Mopidy Logo](https://raw.githubusercontent.com/mopidy/mopidy/develop/docs/_static/mopidy.png)

## Table of Contents

-   [How to use this image](#how-to-use-this-image)
    -   [Getting the image](#getting-the-image)
    -   [Example usage](#example-usage)
-   [Configuration](#configuration)
    -   [Using a custom Mopidy configuration](#using-a-custom-mopidy-configuration)
    -   [Mopidy addons](#mopidy-addons)
    -   [Setting Up Sound in the Container](#setting-up-sound-in-the-container)
-   [License](#license)

## How to use this image
### Getting the image
Pull the latest version of the Mopidy image from Docker Hub:
```bash
$ docker pull 01devmath/mopidy
```

### Example usage
```bash
$ docker run -d --name mopidy-server \
    -e MOPIDY_ADDONS="Mopidy-MPD==3.3.0 git+https://github.com/natumbri/mopidy-youtube.git@develop#egg=Mopidy-YouTube mopidy-ytmusic==0.3.8 pytube==12.1.3 yt-dlp==2023.12.30" \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    -v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
    -v ~/.config/mopidy:/mopidy/config \
    -p 127.0.0.1:6600:6600 \
    01devmath/mopidy
```

(Make sure to expose the ports used in your configuration file using the `-p` option in the `docker run` command.)

## Configuration
### Using a custom Mopidy configuration
By default, Mopidy will look for its configuration file in `/mopidy/config` inside the container. If you want to use a different configuration file or path, you can specify it using the --config flag ([Read Mopidy docs](https://docs.mopidy.com/en/latest/command/)).

You can pass your configuration file or directory using a [bind mount](https://docs.docker.com/storage/bind-mounts/#choose-the--v-or---mount-flag).  

For example, here I'm using the `-v` flag to access my host Mopidy configuration:

```bash
$ docker run \
	-v ~/.config/mopidy:/mopidy/config \
	# other argumments...
	01devmath/mopidy
```

You can find a Mopidy example configuration to use with this container in my [dotfiles](https://github.com/dev-math/dotfiles/blob/main/dot_config/mopidy/mopidy.conf.tmpl).

### Mopidy addons
You can customize the Mopidy installation by specifying additional addons using the `MOPIDY_ADDONS` environment variable. The addons should be specified following the naming conventions used on PyPI for the respective packages.
You can find a list of available Mopidy extensions on the [Mopidy Extensions page](https://mopidy.com/ext/).

For example, to install the MPD addon and use YouTube with Mopidy, you can pass the addons with the `-e` flag, like this:

```bash
$ docker run \
	-e MOPIDY_ADDONS="Mopidy-MPD Mopidy-YouTube mopidy-ytmusic pytube yt-dlp"
	# other argumments...
	01devmath/mopidy
```
### Setting Up Sound in the Container
For information on setting up sound in Docker with Pulseaudio or ALSA, refer to [Container sound: ALSA or Pulseaudio](https://github.com/mviereck/x11docker/wiki/Container-sound:-ALSA-or-Pulseaudio).

Note:
- In the ['Example usage'](#example-usage) section, Pulseaudio is used with a shared socket, and my pulseaudio cookie is located in `~/.config/pulse/cookie`. You may need to adjust this based on your setup.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
