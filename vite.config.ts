import { resolve } from "path";
import { defineConfig } from "vite";

export default defineConfig({
  build: {
    outDir: resolve(__dirname, "./build"),
    lib: {
      entry: resolve(__dirname, "./plugins/app.plugin.ts"),
      formats: ["cjs"],
      fileName: "app.plugin",
    },
    rollupOptions: {
      external: ["expo/config-plugins"],
      output: {
        globals: {
          "expo/config-plugins": "expo/config-plugins",
        },
      },
    },
  },
});
