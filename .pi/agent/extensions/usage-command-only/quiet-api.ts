import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

/** Give only pi-usage a quiet UI; never mutate Pi's shared context. */
export function withoutUsageStatus(pi: ExtensionAPI): ExtensionAPI {
    const contexts = new WeakMap<ExtensionContext, ExtensionContext>();

    function quietContext<T extends ExtensionContext>(ctx: T): T {
        const cached = contexts.get(ctx);
        if (cached) return cached as T;

        const ui = new Proxy(ctx.ui, {
            get(target, property) {
                if (property === "setStatus") {
                    return (key: string, text: string | undefined) => {
                        if (key !== "usage") target.setStatus(key, text);
                    };
                }
                const value = Reflect.get(target, property, target);
                return typeof value === "function" ? value.bind(target) : value;
            },
        });
        const wrapped = new Proxy(ctx, {
            get(target, property) {
                if (property === "ui") return ui;
                // Keep live getters and methods bound to the original context.
                const value = Reflect.get(target, property, target);
                return typeof value === "function" ? value.bind(target) : value;
            },
        });
        contexts.set(ctx, wrapped);
        return wrapped;
    }

    return new Proxy(pi, {
        get(target, property) {
            if (property === "on") {
                return (event: string, handler: (event: unknown, ctx: ExtensionContext) => unknown) =>
                    Reflect.apply(target.on, target, [
                        event,
                        (event: unknown, ctx: ExtensionContext) => handler(event, quietContext(ctx)),
                    ]);
            }
            if (property === "registerCommand") {
                return (name: string, options: Parameters<ExtensionAPI["registerCommand"]>[1]) =>
                    target.registerCommand(name, {
                        ...options,
                        handler: (args, ctx) => options.handler(args, quietContext(ctx)),
                    });
            }
            const value = Reflect.get(target, property, target);
            return typeof value === "function" ? value.bind(target) : value;
        },
    });
}
