#!/bin/zsh

source ~/.zshrc

# Check if API key and prompt are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <API_KEY> \"<PROMPT>\" [SAVE_DIRECTORY]"
    exit 1
fi

# Assign command line arguments to variables
API_KEY="$1"
PROMPT="$2"

# Optional directory to save all generated images
if [ $# -ge 3 ]; then
    SAVE_DIR="$3"
    mkdir -p "$SAVE_DIR"
else
    SAVE_DIR=""
fi

# Internal directory used by the script to queue images for the next run
QUEUED_DIR="./queued-images"
# Force a refresh of the desktop
killall Dock

# Ensure the queued images directory exists
mkdir -p "$QUEUED_DIR"

# Detect the number of connected displays
NUM_DISPLAYS=$(system_profiler SPDisplaysDataType | grep -c "Resolution:")
if [ "$NUM_DISPLAYS" -eq 0 ]; then
    NUM_DISPLAYS=1
fi

echo "Number of displays detected: $NUM_DISPLAYS"
# # Force a refresh of the desktop
# killall Dock

# Ensure 'wallpaper-cli' is installed
if ! command -v wallpaper &>/dev/null; then
    echo "'wallpaper-cli' is not installed. Please install it using:"
    echo "npm install --global wallpaper-cli"
    exit 1
fi

# Set wallpapers from previous images in the queued directory
echo "Setting wallpapers from $QUEUED_DIR"
for ((index = 1; index <= NUM_DISPLAYS; index++)); do
    # Add a delay before setting each wallpaper
    sleep 1
    # Note: wallpaper-cli uses zero-based indexing
    SCREEN_INDEX=$((index - 1))
    IMAGE_FILE="$QUEUED_DIR/wallpaper_display_${index}.png"

    if [ -f "$IMAGE_FILE" ]; then
        # Print the command that sets the wallpaper
        echo "Running command: wallpaper \"$IMAGE_FILE\" --screen=$SCREEN_INDEX"

        # Set the wallpaper and capture any output or errors
        WALLPAPER_OUTPUT=$(wallpaper "$IMAGE_FILE" --screen=$SCREEN_INDEX 2>&1)

        if [ $? -eq 0 ]; then
            echo "Wallpaper set successfully for display $index"
        else
            echo "Failed to set wallpaper for display $index"
            echo "Error: $WALLPAPER_OUTPUT"
        fi
    else
        echo "No queued wallpaper found for display $index"
    fi
done

# Force a refresh of the desktop
killall Dock
# Now proceed to generate new images
echo "Generating new wallpapers..."

# Prepare the request payload template (unchanged)
REQUEST_PAYLOAD_TEMPLATE='{
    "prompt": "$PROMPT",
    "n": 1,
    "size": "1792x1024",
    "quality": "hd",
    "model": "dall-e-3"
}'

# Loop over each display, generate an image, and save it to QUEUED_DIR
for ((index = 1; index <= NUM_DISPLAYS; index++)); do
    echo "Processing display $index"

    # Prepare the request payload for this display
    REQUEST_PAYLOAD=$(echo "$REQUEST_PAYLOAD_TEMPLATE" | sed "s/\\\$PROMPT/$PROMPT/g")

    # Print the request payload for debugging
    echo "Request payload for display $index: $REQUEST_PAYLOAD"

    # Request image generation from OpenAI API
    RESPONSE=$(curl -s https://api.openai.com/v1/images/generations \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d "$REQUEST_PAYLOAD")

    # Print the response for debugging
    echo "API response for display $index: $RESPONSE"

    # Extract image URL from the API response
    IMAGE_URL=$(echo "$RESPONSE" | grep -o '"url": "[^"]*' | grep -o 'http[^"]*')

    # Check if an image URL was found
    if [ -z "$IMAGE_URL" ]; then
        echo "Failed to retrieve image URL from API response for display $index."
        continue
    fi

    # Download the generated image
    QUEUED_IMAGE_FILE="$QUEUED_DIR/wallpaper_display_${index}.png"
    echo "Downloading image to: $QUEUED_IMAGE_FILE"
    curl -s "$IMAGE_URL" -o "$QUEUED_IMAGE_FILE"

    # Verify that the image was downloaded
    if [ -f "$QUEUED_IMAGE_FILE" ]; then
        echo "Image downloaded successfully for display $index"
    else
        echo "Failed to download image for display $index"
        continue
    fi

    # Print the URL and the path where the image is saved
    echo "Image URL for display $index: $IMAGE_URL"
    echo "Saved to queued images: $QUEUED_IMAGE_FILE"

    # Save a copy to the SAVE_DIR with a timestamp if SAVE_DIR is provided
    if [ -n "$SAVE_DIR" ]; then
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        SAVE_IMAGE_FILE="$SAVE_DIR/wallpaper_display_${index}_${TIMESTAMP}.png"
        cp "$QUEUED_IMAGE_FILE" "$SAVE_IMAGE_FILE"
        echo "Saved copy to: $SAVE_IMAGE_FILE"
    fi
done

echo "Wallpaper generation process completed."
