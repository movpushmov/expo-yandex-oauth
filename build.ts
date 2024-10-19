import { resolve } from "path";
import { build, InlineConfig } from "vite";
import dts from "vite-plugin-dts";

interface Props {
  entry: string;
  fileName: string;
  out?: string;

  withTypings?: boolean;
}

const getBuildOptions = ({
  entry,
  fileName,
  out,
  withTypings = false,
}: Props): InlineConfig => ({
  build: {
    outDir: resolve(__dirname, out ?? ""),
    emptyOutDir: false,
    lib: {
      entry: resolve(__dirname, entry),
      fileName,
      formats: ["cjs"],
    },
    rollupOptions: {
      external: ["expo/config-plugins", "expo-modules-core"],
      output: {
        globals: {
          "expo/config-plugins": "expo/config-plugins",
          "expo-modules-core": "expo-modules-core",
        },
      },
    },
  },
  plugins: [
    withTypings
      ? dts({
          outDir: resolve(__dirname, out ?? ""),
          entryRoot: resolve(__dirname, entry, "../"),
          staticImport: true,
          insertTypesEntry: true,
          rollupTypes: true,
        })
      : null,
  ].filter(Boolean),
});

async function buildEntries() {
  await build(
    getBuildOptions({
      entry: "./plugins/app.plugin.ts",
      fileName: "app.plugin",
    })
  );

  await build(
    getBuildOptions({
      entry: "./src/index.ts",
      out: "./build",
      fileName: "index",
      withTypings: true,
    })
  );
}

buildEntries();
