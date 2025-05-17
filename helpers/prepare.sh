#!/usr/bin/env nix-shell
#!nix-shell -i bash -p fuc

case "$RUNNER_OS" in
Linux)
  if [ "$BTRFS" = true ]; then
    echo "Make /nix BTRFS RAID0 from /btrfs and /mnt/btrfs"
    sudo touch /btrfs /mnt/btrfs
    sudo chmod 600 /btrfs /mnt/btrfs
    sudo fallocate --zero-range --length "$(($(df --block-size=1 --output=avail / | sed -n 2p) - 2147483648))" /btrfs
    sudo fallocate --zero-range --length "$(df --block-size=1 --output=avail /mnt | sed -n 2p)" /mnt/btrfs
    sudo losetup /dev/loop6 /btrfs
    sudo losetup /dev/loop7 /mnt/btrfs
    sudo mkfs.btrfs --data raid0 /dev/loop6 /dev/loop7
    sudo mkdir /nix
    sudo mount -t btrfs -o compress=zstd /dev/loop6 /nix
    sudo chown "${RUNNER_USER}:" /nix
  elif [ "$(findmnt -bno size /mnt)" -gt 20000000000 ]; then
    df -h -x tmpfs
    echo "/mnt is large, bind mount /mnt/nix"
    sudo install -d -o "$RUNNER_USER" /mnt/nix /nix
    sudo mount --bind /mnt/nix /nix
  fi
  ;;
macOS)
  # This save about 110G disk space, and take about 0.6s
  sudo rmz -rf \
    /Library/Developer/CoreSimulator \
    /Users/runner/Library/Developer/CoreSimulator
  # Disable MDS service on macOS
  sudo mdutil -i off -a || true
  sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist || true
  ;;
esac
