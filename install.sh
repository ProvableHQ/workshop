echo "
Starting installation...
"

if [[ $OSTYPE == 'darwin'* ]]; then

echo "Step 0: Install Command Line Developer Tools"

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
    echo "    Command Line Developer Tools are already installed!"
fi

fi

# Create the .build directory, if it does not already exist.
mkdir -p .build

# Enter the .build directory.
cd .build

echo "
Step 1: Fetching the Leo Github repository..."

## Clone the 'aleo' repository, or pull if it already exists.
#git clone https://github.com/AleoHQ/aleo.git aleo 2> /dev/null || (cd aleo ; git pull)

# Clone the 'leo' repository, or pull if it already exists.
git clone https://github.com/AleoHQ/leo.git leo 2> /dev/null || (cd leo ; git pull)

#echo "
#Step 2: Installing Aleo..."
#
## Install 'aleo'.
#cd aleo && cargo install --locked --path . && cd ..

echo "
Step 2: Installing Leo..."

# Install 'leo'.
cd leo && cargo install --locked --path . && cd ..

echo "
Step 3: Downloading parameters. This will take a few minutes...
"

# Create a new Leo project.
leo new install > /dev/null 2>&1 
cd install 

# Attempt to compile the program until it passes.
# This is necessary to ensure that the universal parameters are downloaded.
declare -i DONE

DONE=1

while [ $DONE -ne 0 ]
do
      leo build 2>&1
      DONE=$?
      sleep 0.5
done

# Remove the program.
cd .. && rm -rf install 

echo "
Installation complete. Open a new Terminal to begin.
"
