#!/bin/bash

# Git Workflow Automation Script
# Save this as 'gitflow.sh' in your ~/bin or any directory in your PATH
# Make it executable: chmod +x gitflow.sh
# Run it from any git repository directory: ./gitflow.sh or gitflow.sh

echo "Starting Git Workflow..."

# 1. Ask for git pull
read -p "Do you want to pull latest changes? (y/n): " pull_choice
if [[ "$pull_choice" =~ ^[Yy]$ ]]; then
    echo "Running: git pull"
    git pull
else
    echo "Skipping git pull..."
fi

# 2. Always stage all changes
echo "Staging all changes..."
git add .

# 3. Ask for commit message
read -p "Do you want to enter a custom commit message? (y/n): " commit_choice
if [[ "$commit_choice" =~ ^[Yy]$ ]]; then
    read -p "Enter your commit message: " user_message
    echo "Committing with message: \"$user_message\""
    git commit -m "$user_message"
else
    echo "Committing with default message: \"WIP\""
    git commit -m "WIP"
fi

# 4. Ask for git push
read -p "Do you want to push changes now? (y/n): " push_choice
if [[ "$push_choice" =~ ^[Yy]$ ]]; then
    echo "Running: git push"
    git push
else
    echo "Skipping git push. Changes are committed locally."
fi

echo "Git workflow completed!"
