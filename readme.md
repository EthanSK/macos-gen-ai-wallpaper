macOS AI-Generated Wallpaper Changer
This script generates AI-generated wallpapers using OpenAI's DALL·E 3 model and sets them on your macOS desktop. It supports multiple displays and can be configured to run at login, changing your wallpapers automatically.

Features
Generates unique wallpapers using AI.
Supports multiple displays.
Saves wallpapers for future use.
Optionally archives all generated wallpapers.
Easy setup with setup.sh.
Prerequisites
macOS 10.14.4 or later.
An OpenAI API key with access to the image generation endpoints.
Node.js and npm (installed via setup.sh if not present).
wallpaper-cli (installed via setup.sh).
Installation
Clone the Repository

bash
Copy code
git clone https://github.com/yourusername/macos-ai-wallpaper.git
cd macos-ai-wallpaper
Run the Setup Script

The setup.sh script will check for npm and install wallpaper-cli.

bash
Copy code
chmod +x setup.sh
./setup.sh
If npm is not installed, the script attempts to install Node.js and npm.
Installs wallpaper-cli globally using npm.
Usage

1. Prepare Your OpenAI API Key
   Obtain your OpenAI API key from the OpenAI Dashboard.

2. Run the Wallpaper Script
   The script generates wallpapers for the next time it's run. On the first run, it won't change your wallpaper immediately but will generate images to be used the next time.

bash
Copy code
chmod +x macos-gen-ai-wallpaper.sh
./macos-gen-ai-wallpaper.sh "<YOUR_API_KEY>" "<YOUR_PROMPT>" [SAVE_DIRECTORY]
YOUR_API_KEY: Your OpenAI API key.
YOUR_PROMPT: The prompt describing the desired image.
SAVE_DIRECTORY (optional): Directory to save all generated wallpapers.
Example:

bash
Copy code
./macos-gen-ai-wallpaper.sh "sk-xxxxxxxxxxxxxxxx" "A breathtaking view of a futuristic city at sunset" ./past-generations 3. Create a Shortcut to Run the Script at Login
To have the script run automatically at login, create a shortcut or use a launch agent.

Using Automator:
Open Automator and create a new Application.

Add a Run Shell Script Action:

Search for "Run Shell Script" in the actions library.
Drag it into the workflow area.
Configure the Shell Script:

Set the shell to /bin/bash.
Set Pass input to "As arguments".
Insert the Following Script:

Replace placeholders with your actual paths and API key.

bash
Copy code
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

cd /path/to/macos-ai-wallpaper

./macos-gen-ai-wallpaper.sh "<YOUR_API_KEY>" "<YOUR_PROMPT>" [SAVE_DIRECTORY]
Example:

bash
Copy code
export PATH=/Users/yourusername/.nvm/versions/node/v14.17.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

cd /Users/yourusername/Projects/macos-ai-wallpaper

./macos-gen-ai-wallpaper.sh "sk-xxxxxxxxxxxxxxxx" "A breathtaking view of an interesting place in the world. Be creative and make it look realistic. It can be anything, surprise me." ./past-generations
Save the Application:

Save it to a location like /Applications.
Add to Login Items:

Go to System Preferences > Users & Groups > Login Items.
Click the "+" button and add your Automator application.
Using Launch Agents:
Alternatively, create a launch agent to run the script at login.

Create a Launch Agent File:

bash
Copy code
nano ~/Library/LaunchAgents/com.username.wallpaperchanger.plist
Insert the Following XML Configuration:

xml
Copy code

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.username.wallpaperchanger</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>/path/to/macos-ai-wallpaper/macos-gen-ai-wallpaper.sh</string>
      <string><YOUR_API_KEY></string>
      <string><YOUR_PROMPT></string>
      <string>/path/to/past-generations</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/wallpaperchanger.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/wallpaperchanger.err</string>
  </dict>
</plist>
Replace placeholders with your actual paths and API key.

Load the Launch Agent:

bash
Copy code
launchctl load ~/Library/LaunchAgents/com.username.wallpaperchanger.plist 4. Notes on Script Behavior
First Run: The script generates wallpapers for the next run. It won't change your current wallpapers on the first execution.
Subsequent Runs: On following runs, the script sets wallpapers from the previously generated images and generates new ones for the next time.
Save Directory: If you specify a SAVE_DIRECTORY, all generated images are saved there with timestamps.
Script Details
macos-gen-ai-wallpaper.sh
Parameters:
<API_KEY>: Your OpenAI API key.
<PROMPT>: Prompt for the AI image generation.
[SAVE_DIRECTORY] (optional): Directory to save all generated wallpapers.
Functionality:
Sets current wallpapers from previously queued images.
Generates new AI wallpapers using the provided prompt.
Saves new wallpapers for use in the next run.
Optionally saves copies of all generated images.
setup.sh
Checks if npm is installed.
Installs Node.js and npm if necessary.
Installs wallpaper-cli globally.
Troubleshooting
Wallpapers Not Changing:
Ensure the script has execute permissions: chmod +x macos-gen-ai-wallpaper.sh.
Verify that wallpaper-cli is installed and accessible.
Check that the images exist in the queued-images directory.
Script Not Running at Login:
Confirm that the Automator application or launch agent is properly configured.
Ensure the script paths and API key are correct.
API Errors:
Check the API response output in the terminal.
Verify that your API key is valid and has the necessary permissions.
Dependencies
Node.js and npm: Required to install wallpaper-cli.

wallpaper-cli: A command-line tool to get or set the desktop wallpaper.

Install via:

bash
Copy code
npm install --global wallpaper-cli
Security Considerations
API Key Safety: Keep your OpenAI API key secure. Do not share it publicly or commit it to version control.
Permissions: The script may require permissions to read/write files and change system settings.
License
This project is licensed under the MIT License.

Acknowledgments
OpenAI: For providing the DALL·E 3 model for image generation.
wallpaper-cli: For enabling programmatic wallpaper changes on macOS.
