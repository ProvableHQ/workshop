
if [[ $OSTYPE == 'darwin'* ]]; then

# Install macOS Command Line Tools
xcode-select --install > /dev/null 2>&1
if [ 0 == $? ]; then
    sleep 1
    osascript <<EOD
tell application "System Events"
    tell process "Install Command Line Developer Tools"
        keystroke return
        click button "Agree" of window "License Agreement"
    end tell
end tell
EOD
else
    echo "Command Line Developer Tools are already installed!"
fi

fi

# Clone the 'aleo' repository, or pull if it already exists.
git clone https://github.com/AleoHQ/aleo.git aleo 2> /dev/null || (cd aleo ; git pull)

# Clone the 'leo' repository, or pull if it already exists.
git clone https://github.com/AleoHQ/leo.git leo 2> /dev/null || (cd leo ; git pull)

# Install 'aleo'.
cd aleo && cargo install --path . && cd ..

# Install 'leo'.
cd leo && cargo install --path . && cd ..
