# Weight Track App

## Description
Weight Track App, called `Statistical Progressive Overload` on the Play Store, is as the name implies and app that can track the weights you use in the gym.
Traditionally, a prediction of what weight to use in your next set exclusively involves guesswork and some amount of experience.
This often leads to miscalculations and "wasted" stets, making workout less efficient.

This app can track what you lifted over time and give smart predictions on what your next weight should be, thus making your time spent in the gym a lot more efficient.
Weight Track App can help you predict and select the correct weight for every set of every exercise, allowing you to make more gains in the same amount of time.

## Build Process
**Note: this was allmost directly copied from the [flutter documentation](https://flutter.dev/docs/deployment/android)**

### Generate Android App Bundle
First generate a key to sign the app with (remember the password you enter in stdin):
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Now generate the app bundle with:
```bash
flutter build appbundle
```

Then create ``./android/key.properties`` containing the following code:
```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<location of the key store file, such as /Users/<user name>/upload-keystore.jks>
```

### Generate APK
Now download `bundletool` from [here]() and execute the following to generate the apk:
```bash
java -jar ~/Downloads/bundletool-all-1.8.0.jar build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=build/weight-track-app.apks
```