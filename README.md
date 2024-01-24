# Mopidy Docker Image

## Building the image

To build the image, navigate to the repository directory and execute the following command:

```bash
docker build -t mopidy .
```

### Mopidy Addons

You can customize the Mopidy installation by specifying additional addons using the MOPIDY_ADDONS build argument. The addons should be specified following the naming conventions used on PyPI for the respective packages.
You can find a list of available Mopidy extensions on the [Mopidy Extensions page](https://mopidy.com/ext/).

The default value for MOPIDY_ADDONS is:
```bash
MOPIDY_ADDONS="Mopidy-MPD Mopidy-YouTube mopidy-ytmusic pytube yt-dlp"
```

For example, to install "Mopidy-MPD" and "Mopidy-Spotify" you can use the following command:

```bash
docker build --build-arg MOPIDY_ADDONS="Mopidy-MPD Mopidy-Spotify" -t mopidy .
```

## Running

### Using your Mopidy config files
- You can pass your configuration file or directory using a [bind mount](https://docs.docker.com/storage/bind-mounts/#choose-the--v-or---mount-flag).

- By default, Mopidy will look for its configuration file in /home/mopidy/.config/mopidy inside the container. If you want to use a different configuration file or path, you can specify it using the --config flag ([Read Mopidy docs](https://docs.mopidy.com/en/latest/command/)).

- You also need to set the `LOCAL_USER_ID` environment variable since some Mopidy addons requires write permissions in some files. 

### Example usage:
```bash
docker run --name mopidy-server \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    -v ~/.config/pulse/cookie:/home/mopidy/.config/pulse/cookie \
    -v ~/.config/mopidy:/home/mopidy/.config/mopidy \
    -p 127.0.0.1:6600:6600 \
    -e LOCAL_USER_ID=$(id -u) \
    mopidy
```

In this example:
- Pulseaudio is used with a shared socket, and my pulseaudio cookie is located in ~/.config/pulse/cookie. You may need to adjust this based on your setup.
- I'm exposing the MPD port with -p 127.0.0.1:6600:6600 to enable the use of ncmpcpp with Mopidy.

For more information on setting up sound in Docker with Pulseaudio or ALSA, refer to [Container sound: ALSA or Pulseaudio](https://github.com/mviereck/x11docker/wiki/Container-sound:-ALSA-or-Pulseaudio).

You can find a Mopidy example configuration to use with this container in my [dotfiles](https://github.com/dev-math/dotfiles/blob/main/dot_config/mopidy/mopidy.conf.tmpl).
