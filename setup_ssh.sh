#! /bin/bash

# This script sets up SSH for a user by creating an SSH directory, generating an SSH key pair, and adding the public key to the authorized keys file.
# Usage: ./setup_ssh.sh <username>

# 0. check environment .env
if [ -f .env ]; then
 export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found. Please create a .env file with the necessary environment variables."
    exit 1
fi

# 1. check GIT_EMAIL
if [ -z "$GIT_EMAIL" ]; then
    echo "Error: GIT_EMAIL is not set in the .env file."
    exit 1
fi

# 2. check GIT_USERNAME
if [ -z "$GIT_USERNAME" ]; then
    echo "Error: GIT_USERNAME is not set in the .env file."
    exit 1
fi

# 2. Create SSH if not exists
SSH_KEY="$HOME/.ssh/id_ed25519"
if [  -f "$SSH_KEY" ]; then
    echo "SSH key already exists at $SSH_KEY. Skipping key generation."
else
    echo "Generating SSH key pair..."
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
    if [ $? -ne 0 ]; then
        echo "Error: Failed to generate SSH key pair."
        exit 1
    fi
    echo "SSH key pair generated successfully."
fi

# 3. Add key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"
if [ $? -ne 0 ]; then
    echo "Error: Failed to add SSH key to ssh-agent."
    exit 1
fi
echo "SSH key added to ssh-agent successfully."

# 4. Display public key to copy
echo "Public key (copy this to your Git hosting service):"
cat "$SSH_KEY.pub"
echo "You can add this public key to your Git hosting service (e.g., GitHub, GitLab, Bitbucket) to enable SSH access."

# 5. Configure Git user
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_USERNAME"


echo "Git user configured with email: $GIT_EMAIL and username: $GIT_USERNAME."

# 6. Test SSH connection
echo "Testing SSH connection..."
ssh -T git@github.com
if [ $? -eq 1 ]; then
    echo "SSH connection test failed. Please check your SSH key and Git hosting service settings."
else
    echo "SSH connection test successful."
fi
# 7. Final message
echo "SSH setup completed successfully. You can now use SSH for Git operations."
# End of script
# 8. Exit script
exit 0
# End of script
# 9. Cleanup
unset GIT_EMAIL
unset GIT_USERNAME