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
Step 1: Fetching the Aleo and Leo Github repositories..."

# Clone the 'aleo' repository, or pull if it already exists.
git clone https://github.com/AleoHQ/aleo.git aleo 2> /dev/null || (cd aleo ; git pull)

# Clone the 'leo' repository, or pull if it already exists.
git clone https://github.com/AleoHQ/leo.git leo 2> /dev/null || (cd leo ; git pull)

echo "
Step 2: Installing Aleo..."

# Install 'aleo'.
cd aleo && cargo install --path . && cd ..

echo "
Step 3: Installing Leo..."

# Install 'leo'.
cd leo && cargo install --path . && cd ..

echo "
Step 4: Downloading the universal parameters. This may take a few minutes..."

# Create a new dummy Leo project.
leo new dummy > /dev/null 2>&1 && cd dummy

# Attempt to compile the dummy program until it passes.
# This is necessary to ensure that the universal parameters are downloaded.
declare -i DONE
declare -i NUMTRIES

DONE=1
NUMTRIES=0

while [ $DONE -ne 0 ]
do
      leo build > /dev/null 2>&1
      DONE=$?
      NUMTRIES+=1
done

# Remove the dummy program.
cd .. && rm -rf dummy

echo "
Installation complete. Open a new Terminal to begin.
"
