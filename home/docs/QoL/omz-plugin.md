The Oh My Zsh framework includes plugins that provide shorthand aliases for common package management commands

For **Arch Linux**, the Arch plugin offers aliases for the `pacman` package manager
For **Fedora**, the Fedora plugin provides aliases for the `dnf` package manager

## Arch Linux - pacman

*   **`pacin`**: Install packages from repositories (`sudo pacman -S`)
*   **`pacupg`**: Update and upgrade packages (`sudo pacman -Syu`)
*   **`pacre`**: Remove packages, keeping config and dependencies (`sudo pacman -R`)
*   **`pacrem`**: Remove packages, including config and unneeded dependencies (`sudo pacman -Rns`)
*   **`pacrep`**: Display info about a package in the repositories (`pacman -Si`)
*   **`pacreps`**: Search for packages in the repositories (`pacman -Ss`)
*   **`pacloc`**: Display info about a locally installed package (`pacman -Qi`)
*   **`paclocs`**: Search for packages in the local database (`pacman -Qs`)
*   **`pacupd`**: Update local package database (`sudo pacman -Sy`)
*   **`pacmir`**: Force refresh of package lists (`sudo pacman -Syy`)
*   **`paclsorphans`**: List orphaned packages (`sudo pacman -Qdt`)
*   **`pacrmorphans`**: Remove all orphaned packages (`sudo pacman -Rs $(pacman -Qtdq)`)

## Fedora - dnf

*   **`dnfin`**: Install packages (`sudo dnf install`)
*   **`dnfse`**: Search for packages (`dnf search`)
*   **`dnfrm`**: Remove packages (`sudo dnf remove`)
*   **`dnfupd`**: Check for updates (`dnf check-update`)
*   **`dnfupg`**: Upgrade packages (`sudo dnf upgrade`)
*   **`dnfif`**: Show package info (`dnf info`)
*   **`dnfre`**: Reinstall package (`sudo dnf reinstall`)
*   **`dnfcln`**: Clean package cache (`dnf clean`)
*   **`dnfdg`**: Downgrade package (`sudo dnf downgrade`)
*   **`dnfhist`**: Show DNF history (`dnf history`)
*   **`dnfls`**: List packages (`dnf list`)
*   **`dnfrepif`**: Show repo info (`dnf repoinfo`)
*   **`dnfrepls`**: List repos (`dnf repolist`)
*   **`dnfrq`**: Query repos (`dnf repoquery`)
*   **`dnfsh`**: Open DNF shell (`sudo dnf shell`)
*   **`dnfupif`**: Show update info (`dnf updateinfo`)
*   **`dnfmin`**: Minimal upgrade (`sudo dnf upgrade-minimal`)
*   **`dnflsi`**: List installed packages (`dnf list --installed`)
*   **`dnflsav`**: List available packages (`dnf list --available`)
*   **`dnf_full_upgrade`**: Update, upgrade, and clean (`dnfupd && dnfupg && dnfcln`)   
