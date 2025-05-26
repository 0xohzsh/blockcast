# Blockcast BEACON Quick Setup

This script provides a one-command setup for running your Blockcast BEACON node using Docker.

## Features

- Installs Docker (if not already installed)
- Clones the official Blockcast BEACON Docker Compose repository
- Starts the BEACON node
- Automatically displays your Hardware ID and Challenge Key for registration

## How to Run

**Run this command in your terminal:**

```sh
bash -i <(curl -s https://raw.githubusercontent.com/0xohzsh/blockcast/refs/heads/master/setup.sh)
```

- On macOS: You will be prompted to install Docker Desktop if it is not already installed.
- On Linux: Docker will be installed automatically (requires sudo privileges).

After setup, your Hardware ID and Challenge Key will be displayed. Use these to register your node at [https://app.blockcast.network/](https://app.blockcast.network?referral-code=yQQ078).

## Show Node ID Again

If you need to display your Hardware ID and Challenge Key again (with BEACON running), run:

```sh
bash -i <(curl -s https://raw.githubusercontent.com/0xohzsh/blockcast/refs/heads/master/setup.sh) --show-node-id
```

## Support

For help, visit [https://app.blockcast.network/](https://app.blockcast.network?referral-code=yQQ078) or join the community.
