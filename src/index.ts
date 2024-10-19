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

type Payload = { token: string; jwtToken: string };
type Listener = (payload: Payload) => void;

export const events = {
  onAuthorized: {
    listen: (listener: Listener) =>
      emitter.addListener("onYandexAuthorized", listener),
  },
};
