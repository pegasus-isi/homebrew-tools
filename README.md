# Pegasus Tools

Homebrew formulas for Pegasus.

## Installing Pegasus and HTCondor

```
brew tap pegasus-isi/tools
# Install without R DAX API
brew install pegasus
# Install with R DAX API
brew install pegasus --with-r-api
```

## Running HTCondor

```
brew tap homebrew/services
brew services start htcondor
```

