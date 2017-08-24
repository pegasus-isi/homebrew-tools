# Pegasus Tools

Homebrew formulas for Pegasus.

## Installing Pegasus and HTCondor

```
brew tap pegasus-isi/tools
# Install with R DAX API
brew install pegasus
# Install without R DAX API
PEGASUS_BUILD_R_MODULES=0 brew install pegasus
```

## Running HTCondor

```
brew tap homebrew/services
brew services start htcondor
```

