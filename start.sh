#!/bin/bash
# UK Data Project - One-command starter (bandwidth-aware)

PROJECT_DIR="$HOME/uk-data-project"

echo "🚀 Starting UK Data Project..."

# Go to project directory
cd "$PROJECT_DIR" || { echo "❌ Cannot find project folder!"; exit 1; }

# Create venv if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python -m venv .venv
fi

# Activate venv
source .venv/bin/activate
echo "✅ Venv activated ($(python --version))"

# Check which packages are missing (very lightweight check)
missing=()
for pkg in pandas matplotlib seaborn jupyter notebook; do
    if ! python -c "import $pkg" &> /dev/null 2>&1; then
        # Special case: notebook is a submodule of jupyter
        if [ "$pkg" = "notebook" ]; then
            if ! python -c "import notebook" &> /dev/null 2>&1; then
                missing+=("notebook")
            fi
        else
            missing+=("$pkg")
        fi
    fi
done

# Install only missing packages
if [ ${#missing[@]} -ne 0 ]; then
    echo "📦 Installing missing packages: ${missing[*]}"
    pip install --quiet "${missing[@]}"
    echo "✅ Packages installed/updated"
else
    echo "✅ All required packages already present"
fi

# Create .gitignore if missing
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'GITIGNORE'
.venv/
__pycache__/
*.pyc
*.pyo
raw_data.csv
*.csv
*.ipynb_checkpoints/
GITIGNORE
    echo "✅ .gitignore created"
fi

echo ""
echo "🎉 Project ready!"
echo "→ Jupyter Notebook will start shortly. Open the URL shown below in your browser."
echo ""

# Start Jupyter
jupyter notebook
