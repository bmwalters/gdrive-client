# gdrive-client

A Google Drive CLI with automatic OAuth token management.

## Scripts

### `gdrive`
Main CLI that wraps [restish](https://rest.sh/) with automatic token management via macOS Keychain.

On first use, automatically downloads and configures the Google Drive OpenAPI spec.

```bash
gdrive files-list
gdrive files-get FILE_ID
gdrive files-export FILE_ID --mime-type text/markdown
```

### `auth-google`
OAuth2 wrapper around [oauth2c](https://github.com/cloudentity/oauth2c). Outputs token JSON to stdout.

```bash
# Initial authorization (opens browser)
./auth-google --scopes "https://www.googleapis.com/auth/drive.readonly"

# Refresh token
./auth-google --refresh-token "$REFRESH_TOKEN"
```

## Setup

### Prerequisites

```bash
brew install cloudentity/tap/oauth2c restish
```

- `oauth2c` - OAuth2 CLI for authentication
- `restish` - OpenAPI-driven REST CLI

### Configuration

Create `~/.config/auth-google/config`:

```bash
GOOGLE_CLIENT_ID="your-client-id"
GOOGLE_CLIENT_SECRET="your-client-secret"
```

### Installation

```bash
make install PREFIX="$HOME/.local"
```

This installs:
- `gdrive` and `auth-google` scripts to `~/.local/bin`
- Fish completions to `~/.config/fish/completions`

Make sure `~/.local/bin` is in your `PATH`.

## Token Storage

Tokens are stored in macOS Keychain under service `gdrive-auth`:
- `access_token` - Short-lived access token
- `refresh_token` - Long-lived refresh token (protected by device passcode)

The refresh token is stored with no default app access (`-T ""`), so macOS prompts for confirmation when it's accessed. This protects the long-lived credential from silent exfiltration.

The `gdrive` script automatically:
1. Downloads the OpenAPI spec on first use
2. Uses the access token from keychain
3. Refreshes the token if it expires (401 response) — prompts for keychain access
4. Initiates full OAuth flow if refresh fails

To clear stored tokens:
```bash
security delete-generic-password -s gdrive-auth -a access_token
security delete-generic-password -s gdrive-auth -a refresh_token
```

To re-download the API spec:
```bash
rm -rf ~/Library/Caches/gdrive-cli
gdrive --help
```
