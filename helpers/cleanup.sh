#!/usr/bin/env nix-shell
#!nix-shell -i bash -p fuc

case "$RUNNER_OS" in
Linux)
  if [ "$CLEAN" = true ]; then
    echo "Disk clean, before:"
    df -h -x tmpfs
    sudo rmz -rf \
      /etc/skel/.cargo \
      /etc/skel/.dotnet \
      /etc/skel/.rustup \
      /home/runner/.cargo \
      /home/runner/.dotnet \
      /home/runner/.rustup \
      /home/runneradmin/.cargo \
      /home/runneradmin/.dotnet \
      /home/runneradmin/.rustup \
      /opt/az \
      /opt/google \
      /opt/hostedtoolcache \
      /opt/microsoft \
      /opt/pipx \
      /root/.sbt \
      /usr/lib/google-cloud-sdk \
      /usr/lib/jvm \
      /usr/local \
      /usr/share/az_* \
      /usr/share/dotnet \
      /usr/share/miniconda \
      /usr/share/swift
    docker image prune --all --force >/dev/null
    echo
    echo "After:"
    df -h -x tmpfs
    echo
  fi
  ;;
macOS)
  if [ "$CLEAN" = true ]; then
    echo "Disk clean, before:"
    df -h /
    sudo rmz -rf \
      /Applications/Xcode_* \
      /Library/Developer/CoreSimulator \
      /Library/Frameworks \
      /Users/runner/.dotnet \
      /Users/runner/.rustup \
      /Users/runner/Library/Android \
      /Users/runner/Library/Caches \
      /Users/runner/Library/Developer/CoreSimulator \
      /Users/runner/hostedtoolcache
    echo
    echo "After:"
    df -h /
  fi
  ;;
esac
