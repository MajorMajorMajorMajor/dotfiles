# Progress

## Goal
Run Windows executables from the main SSD Windows partition on this NixOS install (running from microSD on Surface Pro 2017).

## What we completed

### 1) Identified and mounted the Windows partition
- Found Windows partition as: `/dev/nvme0n1p3` (NTFS, label `Local Disk`)
- Mounted manually at: `/mnt/windows`
- Verified successful mount:
  - FS type: `ntfs3`
  - Mounted read-write

### 2) Enabled agent-driven privileged mounting workflow
- Confirmed agent cannot do interactive sudo password entry.
- Added targeted `sudoers` NOPASSWD rules (for mount/mkdir/umount with exact paths), so mount operations can be executed non-interactively when needed.

### 3) Verified Wine from Nix registry source
- Confirmed working registry alias and ran Wine via flake registry source `np`.
- Verified Wine version launch with `nix run np#wineWowPackages.stable`.

### 4) Verified executing Windows apps from mounted partition
- CLI app test succeeded:
  - `7-Zip` binary under `/mnt/windows/Program Files/7-Zip/7z.exe` ran successfully.
- GUI app test succeeded:
  - `7zFM.exe` launched and ran.
- Observed HiDPI scaling limitations in Wine UI; tested DPI and virtual desktop options.

### 5) Deep TurboTax testing and tuning
- Initial direct launch failed due to missing runtimes (`mfc110.dll`) and .NET issues.
- Installed required Wine components with winetricks in a dedicated prefix:
  - `corefonts`, `vcrun2012`, `dotnet452`, Windows version tweaks
- Settled on dedicated prefix workflow:
  - `WINEPREFIX=$HOME/.wine-turbotax64`
- Added `samba` in runtime environment for auth helpers when launching.
- Final result: **TurboTax 2025 launched and worked surprisingly well** from the mounted Windows partition.

## Working launch command (TurboTax)
```bash
WINEPREFIX=$HOME/.wine-turbotax64 nix shell np#wineWowPackages.stable np#samba -c \
  wine "/mnt/windows/Program Files (x86)/TurboTax 2025/tt2025.exe"
```

## Current status
✅ Core objective achieved: running Windows executables (including TurboTax) from the Windows SSD partition on this NixOS setup.
