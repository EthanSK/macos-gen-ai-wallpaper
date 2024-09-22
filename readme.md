# macOS AI Wallpaper Generator

This script generates AI wallpapers for your macOS system using OpenAI's DALL-E 3 model. It automatically sets the generated images as your desktop background on login, and generates some for the next time (works for multiple displays)

## Prerequisites

- macOS operating system
- Node.js and npm
- Homebrew package manager (if you don't have npm, brew will install npm, or actually just install npm yourself up to u)
- OpenAI API key

## Installation

1. Clone this repository:

   ```
   git clone https://github.com/yourusername/macos-gen-ai-wallpaper.git
   cd macos-gen-ai-wallpaper
   ```

2. Run the setup script to install dependencies:

   ```
   ./setup.sh
   ```

   This script will install the required dependencies, including the `wallpaper-cli` tool.

### First Run

Run the script manually the first time to generate the initial set of wallpapers:

```
./macos-gen-ai-wallpaper.sh "YOUR_API_KEY" "Your prompt here" ./past-generations
```

This will create a queue of images for the next run.

### Automatic Run on Login

Create a macOS shortcut (in shortcuts.app) that runs this script

```bash

PATH=<whatever your path is when you echo $PATH>

cd <path to project>/macos-gen-ai-wallpaper-on-login

./macos-gen-ai-wallpaper.sh "<YOUR_API_KEY>" "<Your prompt here>" <past-generations-dir-to-save(optional)>
```

Get [Shortery](https://apps.apple.com/us/app/shortery/id1594183810?mt=12) (it's free) and set it to run the shortcut on login

Now, the script will run automatically each time you log in, setting a new AI-generated wallpaper straight away (from the queue) and generating new images for the next run
