import { ExpoConfig } from "@expo/config-types";
import { withInfoPlist } from "expo/config-plugins";

export default function (rootConfig: ExpoConfig, { clientId }) {
  return withInfoPlist(rootConfig, (config) => {
    config.modResults.LSApplicationQueriesSchemes = [
      "primaryyandexloginsdk",
      "secondaryyandexloginsdk",
    ];

    config.modResults.CFBundleURLTypes = [
      {
        CFBundleURLName: "YandexLoginSDK",
        CFBundleURLSchemes: [`yx${clientId}`],
      },
    ];

    config.modResults.YANDEX_OAUTH_CLIENT_ID = clientId;

    return config;
  });
}
