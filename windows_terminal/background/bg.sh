#!/bin/bash

# Stop script at first error
set -e

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source the .env file to get API_KEY and the path to the settings
source "$SCRIPT_DIR/.env"

# Convert Windows path to WSL path
WSL_PATH_TO_SETTINGS=$(wslpath "$WINDOWS_PATH_TO_SETTINGS")

# Print help message
print_help() {
  echo "Usage: bg [COMMAND] [ARGUMENT]"
  echo ""
  echo "Commands:"
  echo "  change [IMAGE_NAME]   Change the background image to a new one or the named image"
  echo "  save [IMAGE_NAME]     Save the current background image and give it the input name"
  echo "  ls                    List all backgrounds available in the images folder"
  echo ""
  echo "Options:"
  echo "  -h, --help       Show help message"
  echo ""
  echo "Example:"
  echo "  bg change"
  echo "  bg change my_image_name"
  echo "  bg save"
  echo "  bg save my_image_name"
  echo "  bg ls"
}

# Initialize variables
COMMAND=""
IMAGE_NAME=""

# Parse command-line options
while [ "$#" -gt 0 ]; do
  case "$1" in
    change|save)
      COMMAND="$1"
      shift
      case "$1" in
        -*|"") # Do nothing if next argument is another option or empty
          ;;
        *)
          IMAGE_NAME="$1"
          shift
          ;;
      esac
      ;;
    ls)
      COMMAND="$1"
      shift
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      echo "Unknown command: $1" >&2
      print_help
      exit 1
      ;;
  esac
done

# Check if a command was provided
if [ -z "$COMMAND" ]; then
  echo "No command provided. What do we do chief ?" >&2
  print_help
  exit 1
fi

# Execute the change command
if [ "$COMMAND" == "change" ]; then

  # Check if a custom image name was provided
  if [[ -n $IMAGE_NAME ]]; then
    # Load an existing image
    IMAGE_PATH=$(find "$SCRIPT_DIR/images/" -type f -iname "$IMAGE_NAME.*" -print -quit)
    if [[ -n $IMAGE_PATH ]]; then
      WINDOWS_IMAGE_PATH=$(wslpath -w "$IMAGE_PATH")
      jq --arg image_url "$WINDOWS_IMAGE_PATH" '.profiles.defaults.backgroundImage = $image_url' "$WSL_PATH_TO_SETTINGS" > temp.json && mv temp.json "$WSL_PATH_TO_SETTINGS"
      echo "Background image changed to $IMAGE_PATH"
    else
      echo "Image with the name '$IMAGE_NAME' not found in the images folder"
      exit 1
    fi

  else
    # Fetch a new image online based on the keyword list

    # Define a list of keywords
    mapfile -t KEYWORD_LIST < "$SCRIPT_DIR/keywords.txt"

    # Randomly pick a keyword from the list
    KEYWORD=${KEYWORD_LIST[RANDOM % ${#KEYWORD_LIST[@]}]}

    # Randomly pick a page number between 1 and 10
    RANDOM_PAGE=$((RANDOM % 10 + 1))

    # Call Pexels API and store the response in a variable
    API_RESPONSE=$(curl -s -H "Authorization: $PEXELS_API_KEY" \
      -G "https://api.pexels.com/v1/search" \
      --data-urlencode "query=$KEYWORD" \
      --data-urlencode "page=$RANDOM_PAGE" \
      --data-urlencode "per_page=1" \
      --data-urlencode "orientation=landscape")

    # Extract the src.landscape property from the API response
    IMAGE_URL=$(echo "$API_RESPONSE" | jq -r '.photos[0].src.landscape')

    # Update the backgroundImage property in the settings.json file using jq
    jq --arg image_url "$IMAGE_URL" '.profiles.defaults.backgroundImage = $image_url' "$WSL_PATH_TO_SETTINGS" > temp.json && mv temp.json "$WSL_PATH_TO_SETTINGS"
  fi

# Execute the save command
elif [ "$COMMAND" == "save" ]; then

  # Get the current backgroundImage URL from settings.json
  CURRENT_IMAGE_URL=$(jq -r '.profiles.defaults.backgroundImage' "$WSL_PATH_TO_SETTINGS")

  # Remove query parameters from the URL
  CLEAN_IMAGE_URL="${CURRENT_IMAGE_URL%%\?*}"

  # Download the image
  TEMP_IMAGE_PATH="$SCRIPT_DIR/temp_image"
  curl -s -o "$TEMP_IMAGE_PATH" "$CURRENT_IMAGE_URL"

  # Get the image extension
  IMAGE_EXTENSION=$(file --mime-type "$TEMP_IMAGE_PATH" | awk '{print $NF}' | awk -F'/' '{print $NF}')

  # Check if the user has provided a custom name, otherwise use the original filename
  if [[ -n $IMAGE_NAME ]]; then
    IMAGE_FILENAME="$IMAGE_NAME.$IMAGE_EXTENSION"
  else
    IMAGE_FILENAME=$(basename "$CLEAN_IMAGE_URL")
  fi

  # Save the image to the "$SCRIPT_DIR/images" folder with the custom or original name
  mv "$TEMP_IMAGE_PATH" "$SCRIPT_DIR/images/$IMAGE_FILENAME"
  echo "Image saved to $SCRIPT_DIR/images/$IMAGE_FILENAME"

# Execute the ls command
elif [ "$COMMAND" == "ls" ]; then

  # List all image names without extensions in the images folder
  echo "Backgrounds in the \"$SCRIPT_DIR/images\" folder:"
  for image in "$SCRIPT_DIR/images/"*; do
    if [[ -f "$image" ]]; then
      image_name=$(basename "$image")
      image_name_without_extension="${image_name%.*}"
      echo "  - $image_name_without_extension"
    fi
  done

else
  echo "Invalid command: $COMMAND" >&2
  print_help
  exit 1
fi
