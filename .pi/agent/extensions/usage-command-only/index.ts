import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import usage from "../../npm/node_modules/@narumitw/pi-usage/dist/index.ts";
import { withoutUsageStatus } from "./quiet-api.ts";

export default function (pi: ExtensionAPI) {
    return usage(withoutUsageStatus(pi));
}
