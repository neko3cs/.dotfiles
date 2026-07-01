#!/usr/bin/env python3
import os
import sys
import subprocess


def _is_wsl():
    if os.environ.get("WSL_DISTRO_NAME"):
        return True
    try:
        return "microsoft" in open("/proc/version").read().lower()
    except OSError:
        return False


def _platform_key():
    if sys.platform == "linux" and _is_wsl():
        return "wsl"
    return sys.platform  # darwin / win32


def play(event="notification"):
    key = _platform_key()
    try:
        if key == "darwin":
            sounds = {
                "notification": "/System/Library/Sounds/Glass.aiff",
                "stop":         "/System/Library/Sounds/Funk.aiff",
            }
            subprocess.run(
                ["afplay", sounds.get(event, sounds["notification"])],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            )
        elif key == "win32":
            import winsound
            aliases = {
                "notification": "SystemAsterisk",
                "stop":         "SystemExclamation",
            }
            winsound.PlaySound(
                aliases.get(event, "SystemAsterisk"), winsound.SND_ALIAS
            )
        elif key == "wsl":
            # [System.Media.SystemSounds].Play() は非同期なので Sleep で完奏を待つ
            cmds = {
                "notification": "[System.Media.SystemSounds]::Asterisk.Play(); Start-Sleep -Milliseconds 800",
                "stop":         "[System.Media.SystemSounds]::Exclamation.Play(); Start-Sleep -Milliseconds 800",
            }
            subprocess.run(
                ["powershell.exe", "-c", cmds.get(event, cmds["notification"])],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            )
    except Exception:
        pass


if __name__ == "__main__":
    play(sys.argv[1] if len(sys.argv) > 1 else "notification")
