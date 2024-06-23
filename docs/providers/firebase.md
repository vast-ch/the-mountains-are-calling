# Firebase Realtime Database

## Self hosted provider
1. Sign up for [Firebase](https://firebase.google.com/)
2. Create new project
3. Create new `Realtime Database` within your project
4. Go to `Rules` and set it so that:
   1. It's not possible to read entire database. This prevents `deviceId` enumeration.
   2. Allow reading and writting to all `${subpath}`s. This allows you to use multiple `DeviceId`s. If you want to use this only against _one_ device, you can simply replace `${subpath}` with your own pre-generated `DeviceId`.
```json
{
  "rules": {
    ".read": false,
    ".write": false,
    "${subpath}": {
      ".read": true,
      ".write": true,
      ".indexOn": ["created_at"]
    }
  }
}
```
5. Compose `Provider URL`:
   1. Click on "Copy `reference URL`" (link icon) to 
   2. The format for `Provider URL` will be: `${referenceUrl}/${SOME_LONG_RANDOM_STRING}.json`.
   3. For example: `https://my-own-instance.europe-west1.firebasedatabase.app/xxxxxxx-xxxx-xxxxx-xxxxxx`
6. Use `Provider URL` to configure your `Device`. For quick start see the "Quickstart/Device" section of `README` using the `Automate` app.
6. Use the same `Provider URL` to configure your `Client`. For quick start see the "Quickstart/Client" section of `README` using the [hosted client](https://the-mountains-are-calling.netlify.app/).

## Notes

> [!CAUTION]
> The security here relies on `deviceId` being **long**, **hard to guess** and **secret**. Do **not** share it with parties you don't trust.

> [!CAUTION]
> Although careful thought has been put into the design to strike balance between data privacy & simplicity, it **is** possible that someone smarter than author **will** be able to enumarate the `deviceId` and then read your data.

> [!NOTE]
> To start this project Firebase database has been chosen as the _simplest_, _cheapest_ and _fastest to implement_ solution. It is partially an irony that a project that is trying to take out location data from the big corporations is then storing said data on their infrastructure. But from Google perspective, those are just blobs of JSON without any meaning.
