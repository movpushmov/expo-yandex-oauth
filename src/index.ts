import { EventEmitter, NativeModulesProxy } from "expo-modules-core";

import ExpoYandexOauthModule from "./ExpoYandexOauthModule";

const emitter = new EventEmitter(
  ExpoYandexOauthModule ?? NativeModulesProxy.ExpoYandexOauth
);

export function authorize() {
  return ExpoYandexOauthModule.authorize();
}

export function logout() {
  return ExpoYandexOauthModule.logout();
}

interface ConfigureProps {
  onAuthorized: (props: { token: string }) => void;
}

export function configure(props: ConfigureProps) {
  const { onAuthorized } = props;

  return {
    onAuthorized: emitter.addListener("onYandexAuthorized", onAuthorized),
  };
}
