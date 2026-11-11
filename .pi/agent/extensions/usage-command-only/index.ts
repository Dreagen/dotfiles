import { homedir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { withoutUsageStatus } from "./quiet-api.ts";

// Resolved from ~/.pi/agent rather than relative to this file: stow symlinks
// this file into place, and the loader follows the link back to the dotfiles
// repo, where the npm packages are not installed.
const usagePath = join(
    homedir(),
    ".pi",
    "agent",
    "npm",
    "node_modules",
    "@narumitw",
    "pi-usage",
    "dist",
    "index.ts",
);

export default async function (pi: ExtensionAPI) {
    const { default: usage } = await import(pathToFileURL(usagePath).href);
    return usage(withoutUsageStatus(pi));
}
