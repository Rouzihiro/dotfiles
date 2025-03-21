{pkgs, input ? ""}:
pkgs.writeShellScriptBin "redlight" ''
#!/bin/sh

# Check if redshift is installed
if ! command -v redshift &>/dev/null; then
    echo "Error: 'redshift' is not installed. Install it with: sudo apt install redshift"
    exit 1
fi

# Prompt user for input
echo -n "Enter the desired color temperature (e.g., 4000 for 4000K) or 'x' to reset: "
read input

# Check if the input is "x" for reset
if [[ "$input" == "x" ]]; then
    redshift -x
    echo "Screen color temperature reset to default."
    exit 0
fi

# Validate input is a number
if [[ ! "$input" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter a valid number (e.g., 4000) or 'x' to reset."
    exit 1
fi

# Apply the color temperature
redshift -O "$input"
echo "Screen color temperature set to ${input}K."
''
