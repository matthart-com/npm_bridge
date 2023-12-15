# bridge

Run these commands:

flutter pub get

cd bridge

npm install

npm run build

Open an iOS Simulator. Open an Android simulator.

In Visual Studio Code, bottom right of the window, you can click that and then select a target device to run. Click the |> run section on the left, then click the |> run icon at the top of the window.

The trick to using NPM or other Javascript libraries in Flutter is to use either a javascript context object or a webview with a wrapper object that can execute your desired functions. In our case, we're using a headless webview that loads the webpack index file. The headless webview will return javascript function results.

See /bridge/src/index.js for the test function wrapper.

See lib/main.dart around line 145 to see the function call.