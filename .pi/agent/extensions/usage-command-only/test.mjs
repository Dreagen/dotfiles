import assert from "node:assert/strict";
import { test } from "node:test";
import { withoutUsageStatus } from "./quiet-api.ts";

function fixture() {
    const writes = [];
    const notices = [];
    const handlers = new Map();
    const commands = new Map();
    let model = "first";
    const ui = {
        setStatus(key, text) { assert.equal(this, ui); writes.push([key, text]); },
        notify(text) { assert.equal(this, ui); notices.push(text); },
    };
    const ctx = {
        ui,
        get model() { return model; },
        isIdle() { assert.equal(this, ctx); return true; },
    };
    const pi = {
        on(event, handler) {
            assert.equal(this, pi);
            handlers.set(event, handler);
            return () => handlers.delete(event);
        },
        registerCommand(name, options) {
            assert.equal(this, pi);
            commands.set(name, options);
        },
        events: {},
    };
    return { pi, ctx, writes, notices, handlers, commands, setModel(value) { model = value; } };
}

test("event contexts suppress usage status, including captured async writes", async () => {
    const f = fixture();
    const quiet = withoutUsageStatus(f.pi);
    let captured;
    const unsubscribe = quiet.on("turn_start", (_event, ctx) => {
        captured = ctx;
        ctx.ui.setStatus("usage", "credits");
        return { preserved: true };
    });
    assert.deepEqual(f.handlers.get("turn_start")({}, f.ctx), { preserved: true });
    await Promise.resolve().then(() => captured.ui.setStatus("usage", "updated"));
    captured.ui.setStatus("usage", undefined);
    assert.deepEqual(f.writes, []);
    captured.ui.setStatus("another-status", "visible");
    f.ctx.ui.setStatus("usage", "original UI remains untouched");
    assert.equal(f.writes.length, 2);
    unsubscribe();
    assert.equal(f.handlers.size, 0);
});

test("commands retain metadata, UI, live getters, and errors", async () => {
    const f = fixture();
    const quiet = withoutUsageStatus(f.pi);
    quiet.registerCommand("usage", {
        description: "Usage report",
        handler: async (args, ctx) => {
            ctx.ui.setStatus("usage", "hidden");
            ctx.ui.notify(args);
            f.setModel("second");
            assert.equal(ctx.model, "second");
            assert.equal(ctx.isIdle(), true);
        },
    });
    const command = f.commands.get("usage");
    assert.equal(command.description, "Usage report");
    await command.handler("report", f.ctx);
    assert.deepEqual(f.notices, ["report"]);
    assert.deepEqual(f.writes, []);
    quiet.registerCommand("failure", { handler: async () => { throw new Error("expected"); } });
    await assert.rejects(f.commands.get("failure").handler("", f.ctx), /expected/);
    assert.equal(quiet.events, f.pi.events);
});

test("the real installed package loads once and registers /usage", async () => {
    const { loadExtensions } = await import(
        "/home/nick/.pi/agent/install/releases/1.5.0/node_modules/@earendil-works/pi-coding-agent/dist/core/extensions/loader.js"
    );
    const path = new URL("./index.ts", import.meta.url).pathname;
    const result = await loadExtensions([path], process.cwd());
    assert.deepEqual(result.errors, []);
    assert.equal(result.extensions.length, 1);
    assert.equal(result.extensions[0].commands.has("usage"), true);
});
