# Windows Terminal Background Changer

A CLI tool to change the background of the Windows Terminal using images from Pexels.com or saved locally in the images folder.

## Installation

1. Follow the installation steps of the [custom bash config](../../bash_custom/README.md).

2. Duplicate the `example.env` file and rename it to `.env`.
```sh
cp example.env .env
```

3. Create an account on [Pexels.com](https://www.pexels.com/join-consumer/), and create an API Key via this link [Pexels.com/api](https://www.pexels.com/api/).

4. Update the `.env` file with your Pexels API Key and provide the path to the Windows Terminal settings file.
```
PEXELS_API_KEY=your_pexels_api_key
WINDOWS_PATH_TO_SETTINGS=Path\to\your\Windows\Terminal\settings.json
```

5. Customize [the list of keywords](keywords.txt) to your preference. Those keywords will be used to fetch related wallpapers.

## Usage

You can use this CLI tool to change the background, save the current background image, or list all available backgrounds in the internal images folder.

### Change Background

To change the background to a new image from Pexels.com:
```bash
bg change
```

To change the background to a specific saved image:
```bash
bg change image_name
```

### Save Background

To save the current background image with the original file name:
```bash
bg save
```

To save the current background image with a custom file name:
```bash
bg save custom_image_name
```

### List Available Backgrounds

To list all available backgrounds in the images folder:
```bash
bg ls
```

## Help
To display a help message with all available commands and options:
```bash
bg --help
```
