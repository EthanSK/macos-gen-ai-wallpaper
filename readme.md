# macOS AI Wallpaper Generator

This script generates AI-powered wallpapers for your macOS system using OpenAI's DALL-E 3 model. It automatically sets the generated images as your desktop background on login.

## Prerequisites

- macOS operating system
- Homebrew package manager
- Node.js and npm
- OpenAI API key

## Installation

1. Clone this repository:

   ```
   git clone https://github.com/yourusername/macos-gen-ai-wallpaper-on-login.git
   cd macos-gen-ai-wallpaper-on-login
   ```

2. Run the setup script to install dependencies:

   ```
   ./setup.sh
   ```

   This script will install the required dependencies, including the `wallpaper-cli` tool.

3. Install the `wallpaper-cli` tool globally:
   ```
   npm install --global wallpaper-cli
   ```

## Configuration

1. Open the `macos-gen-ai-wallpaper.sh` script and replace `YOUR_API_KEY` with your actual OpenAI API key.

2. Modify the prompt in the script to customize the type of images you want to generate.

## Usage

### First Run

Run the script manually the first time to generate the initial set of wallpapers:

```
./macos-gen-ai-wallpaper.sh "YOUR_API_KEY" "Your prompt here" ./past-generations
```

This will create a queue of images for the next run.

### Automatic Run on Login

To run the script automatically on login:

1. Open "Automator" on your Mac.
2. Create a new "Application" or "Workflow".
3. Add a "Run Shell Script" action.
4. Paste the following script, adjusting the paths and API key as necessary:

```bash
cd <path to project>/macos-gen-ai-wallpaper-on-login

./macos-gen-ai-wallpaper.sh "YOUR_API_KEY" "Your prompt here" ./past-generations
```

4. Save the Automator application.
5. Go to System Preferences > Users & Groups > Login Items.
6. Add the Automator application you just created to the login items.

Now, the script will run automatically each time you log in, setting a new AI-generated wallpaper.

## How It Works

1. The script checks for existing wallpapers in the queue.
2. If wallpapers exist, it sets them as the current desktop background.
3. It then generates new wallpapers for the next run, storing them in the queue.
4. On the next login, the cycle repeats, ensuring you always have a fresh wallpaper.

## Troubleshooting

If you encounter issues with wallpapers not setting correctly:

1. Check the console for error messages.
2. Ensure the script has necessary permissions.
3. Verify your macOS version is compatible with the AppleScript commands used.

## Contributing

Feel free to fork this repository and submit pull requests for any improvements or bug fixes.

## License

[MIT License](LICENSE)
