#!/usr/bin/env node
import { execFileSync } from "node:child_process";
import { readFileSync } from "node:fs";

function isWSL() {
  if (process.env.WSL_DISTRO_NAME) return true;
  try {
    return readFileSync("/proc/version", "utf8").toLowerCase().includes("microsoft");
  } catch {
    return false;
  }
}

// 実行環境のキー（WSLはWindows側に投げる）
function platformKey() {
  if (process.platform === "linux" && isWSL()) return "wsl";
  return process.platform; // darwin / win32
}

// イベント名 → 環境ごとの [コマンド, 引数]
const SOUNDS = {
  darwin: {
    notification: ["afplay", ["/System/Library/Sounds/Glass.aiff"]],
    stop: ["afplay", ["/System/Library/Sounds/Funk.aiff"]],
  },
  win32: {
    notification: ["powershell", ["-c", "[console]::beep(880,200)"]],
    stop: ["powershell", ["-c", "[console]::beep(440,300)"]],
  },
  wsl: {
    // WSLからは powershell.exe を直接呼べる（Windows側で鳴る）
    notification: ["powershell.exe", ["-c", "[console]::beep(880,200)"]],
    stop: ["powershell.exe", ["-c", "[console]::beep(440,300)"]],
  },
};

export default function play(event = "notification") {
  try {
    const table = SOUNDS[platformKey()];
    if (!table) return;                     // 対象外の環境は静かに終了
    const [cmd, args] = table[event] ?? table.notification;
    execFileSync(cmd, args, { stdio: "ignore" });
  } catch {
    // プレイヤーが無くても落とさない
  }
}
