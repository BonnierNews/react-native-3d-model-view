# react-native-3d-model-view
[![npm version](https://img.shields.io/npm/v/react-native-3d-model-view.svg?style=flat)](https://www.npmjs.com/package/react-native-3d-model-view)
[![npm downloads](https://img.shields.io/npm/dm/react-native-3d-model-view.svg?style=flat)](https://www.npmjs.com/package/react-native-3d-model-view)

A React Native view for displaying .obj, .dae and .scn models either on screen or in AR (iOS devices with A9 or later processors only).

**Example Project**: https://github.com/BonnierNews/react-native-3d-model-view/tree/master/example

## Getting started

`$ yarn add react-native-3d-model-view`

and then

`$ react-native link react-native-3d-model-view`

The lib also have peer dependencies of `react-native-zip-archive`, `rn-fetch-blob` and `react-native-fs`. Make sure that you `yarn add` and `react-native link` them to.

## Swift
The `ARModelView` is written in Swift. So you need to add Swift to your project:
1. Add Swift 4.2 in your [Xcode Build Settings](https://stackoverflow.com/questions/46338588/xcode-9-swift-language-version-swift-version/46339401) (Support for Swift 3 is deprecated. If you still want to use Swift 3, use release [1.1.17](https://github.com/BonnierNews/react-native-3d-model-view/tree/release/1.1.17))
2. Add a `Empty.swift` to your Xcode project (see example project for reference).

## Usage

### Model view
```javascript
import ModelView from 'react-native-3d-model-view'

<ModelView
  source={{ zip: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.zip?raw=true' }}
  onLoadModelStart={this.onLoadModelStart}
  onLoadModelSuccess={this.onLoadModelSuccess}
  onLoadModelError={this.onLoadModelError} />

```
<img src="https://raw.githubusercontent.com/BonnierNews/react-native-3d-model-view/master/screenshots/modelview.png" width="250">

### AR Model view
```javascript
import ARModelView, { ModelTypes } from 'react-native-3d-model-view'

<ARModelView
  source={{ zip: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.zip?raw=true' }}
  onLoadModelStart={this.onLoadModelStart}
  onLoadModelSuccess={this.onLoadModelSuccess}
  onLoadModelError={this.onLoadModelError}
  onStart={this.onStart}
  onSurfaceFound={this.onSurfaceFound}
  onSurfaceLost={this.onSurfaceLost}
  onSessionInterupted={this.onSessionInterupted}
  onSessionInteruptedEnded={this.onSessionInteruptedEnded}
  onPlaceObjectSuccess={this.onPlaceObjectSuccess}
  onPlaceObjectError={this.onPlaceObjectError}
  onTrackingQualityInfo={this.onTrackingQualityInfo} />

```

<img src="https://raw.githubusercontent.com/BonnierNews/react-native-3d-model-view/master/screenshots/arview.png" width="250">

## Source
The source prop on both `ModelView` and `ARView` can either be a url to a server (e.g. http://example.com/yourmodel.obj) or a local path (use `require`). The source object can either consist of a `zip` prop or a `model` and a `texture` prop. Examples:

```javascript
source={{
  zip: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.zip?raw=true'
}}
```
or
```javascript
source={{
  zip: require('../obj/Hamburger.zip')
}}
```
or
```javascript
source={{
  model: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.obj?raw=true',
  texture: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.png?raw=true'
}}
```
or
```javascript
source={{
  model: require('../obj/Hamburger.obj'),
  texture: require('../obj/Hamburger.png')
}}
```
The lib will assume that the unzipped folder result will have the same name as the .zip (e.g. `Hamburger.zip` => `Hamburger`). This might not always be the case, then you can set the name of the unzipped folder:
```javascript
source={{
  zip: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Archive.zip?raw=true',
  unzippedFolderName: 'Hamburger'
}}
```
### NOTE: File types
WaveFront (.obj) and Collada (.dae) is supported on both Android and iOS. SceneKit (.scn) is supported on iOS. Collada models with animations is autoplayed.

### NOTE: Using `require`
To require .obj, .dae, .scn or .zip files you need to add a `rn-cli.config.js` to the root of your project with minimum this config:
```javascript
const { getDefaultConfig } = require("metro-config");

module.exports = (async () => {
  const { resolver: { assetExts } } = await getDefaultConfig();

  return { resolver: { assetExts: assetExts.concat(['obj', 'dae', 'scn', 'zip']) } };
})();
```
See more in the [example project.](https://github.com/BonnierNews/react-native-3d-model-view/tree/master/example)

### NOTE: SceneKit compressed scenes
SceneKit and Collade files needs to be "SceneKit compressed scenes" on iOS. Compress with this shell command
```bash
$ /Applications/Xcode.app/Contents/Developer/usr/bin/scntool --convert InFile.dae --format c3d --output OutFile.dae --force-y-up --force-interleaved --look-for-pvrtc-image
```
More info: [developer.apple.com](https://developer.apple.com/documentation/scenekit/scnscenesource#//apple_ref/occ/cl/SCNSceneSource) and [stackoverflow.com](https://stackoverflow.com/a/30115411)

## Components

### ModelView

View for displaying .obj, .dae or .scn (iOS only) on screen with SceneKit or OpenGL.

#### Props
| Prop | Type | Default | Note |
|---|---|---|---|
|`source`|`object`|`null`|Can either consist of a `zip` prop or a `model` and a `texture` prop. All three can either be a url `string` ("http://...") or you can use `require` to reference a local path. The .zip archive should contain both the object and the texture. Can also contain `unzippedFolderName` for setting the unzipped folder name (see more above).|
|`scale`|`number`|`1`|Scale of the model.|
|`autoPlay`|`boolean`|`true`|Should animated models play on mount.|

#### Events
| Event Name | Returns | Notes |
|---|---|---|
|`onLoadModelStart`|`null`|Loading model has started.|
|`onLoadModelSuccess`|`null`|Loading model has succeeded.|
|`onLoadModelError`|`Error`|Failed loading model.|
|`onAnimationStart`|`null`|Animated model has started animating.|
|`onAnimationStop`|`null`|Animated model has stopped animating.|
|`onAnimationUpdate`|`event`|Animated model animation update. Get progress from `event.nativeEvent.progress`|


#### Methods
Use `ref={modelView => {this.modelView = modelView}}` to be able to call the methods listed below.

| Method Name | Returns | Notes |
|---|---|---|
|`startAnimation`|`null`|Start playing animated model.|
|`stopAnimation`|`null`|Stops playing animated model.|
|`setProgress(float)`|`null`|Set animation progress of animated model (allowed values: 0-1).|

### ARModelView

View for displaying .obj, .dae or .scn in augmented reality (iOS devices with A9 or later processors only).

#### Props
| Prop | Type | Default | Note |
|---|---|---|---|
|`source`|`object`|`null`|Can either consist of a `zip` prop or a `model` and a `texture` prop. All three can either be a url `string` ("http://...") or you can use `require` to reference a local path. The .zip archive should contain both the object and the texture. Can also contain `unzippedFolderName` for setting the unzipped folder name (see more above). |
|`scale`|`number`|`1`|Scale of the model.|
|`autoPlay`|`boolean`|`true`|Should animated models play on mount.|
|`miniature`|`boolean`|`false`|Shows the model in a miniature mode.|
|`miniatureScale`|`float`|`0.2`|The scale of the model in miniature mode.|
|`placeOpacity`|`float`|`0.2`|The opacity of the model when placing.|

#### Events
| Event Name | Returns | Notes |
|---|---|---|
|`onLoadModelStart`|`null`|Loading model has started.|
|`onLoadModelSuccess`|`null`|Loading model has succeeded.|
|`onLoadModelError`|`Error`|Failed loading model.|
|`onAnimationStart`|`null`|Animated model has started animating.|
|`onAnimationStop`|`null`|Animated model has stopped animating.|
|`onAnimationUpdate`|`event`|Animated model animation update. Get progress from `event.nativeEvent.progress`|
|`onStart`|`null`||
|`onSurfaceFound`|`null`||
|`onSurfaceLost`|`null`||
|`onSessionInterupted`|`null`||
|`onSessionInteruptedEnded`|`null`||
|`onPlaceObjectSuccess`|`null`||
|`onPlaceObjectError`|`null`||
|`onTrackingQualityInfo`|`{id: number, presentation: string, recommendation: string`|The current info about the tracking quality.|
|`onTapObject`|`null`|Called when tapped an object in the AR scene.|
|`onTapView`|`null`|Called when tapped the screen but no object was hit by the tap.|


#### Methods
Use `ref={arView => {this.arView = arView}}` to be able to call the methods listed below.

| Method Name | Returns | Notes |
|---|---|---|
|`startAnimation`|`null`|Start playing animated model.|
|`stopAnimation`|`null`|Stops playing animated model.|
|`setProgress(float)`|`null`|Set animation progress of animated model (allowed values: 0-1).|
|`restart`|`null`|Restarts the ARKit session.|
|`getSnapshot(boolean)`|`Promise`|Save a print screen of the current AR session. Boolean determines if the image should be saved to the Photo Library of the device. The promise return the url of the saved image.|

## Native modules

### Manager
Manager for common actions needed for the `ModelView`.

| Method Name | Returns | Notes |
|---|---|---|
|`clearDownloadedFiles`|`null`|Removes all downloaded model assets from the device. **Should be called when exiting the app**|

### ARManager
Manager for common actions needed for the `ARModelView`.

| Method Name | Returns | Notes |
|---|---|---|
|`clearDownloadedFiles`|`null`|Removes all downloaded model assets from the device. **Should be called when exiting the app**|
|`checkIfARSupported(callback)`|`null`|Check if ARKit is supported on the current device. Callback params is a boolean saying if it is supported or not.|

## Contributing

If you find a bug or would like to request a new feature, just [open an issue](https://github.com/BonnierNews/react-native-3d-model-view/issues/new). You are also welcome to submit pull requests and contribute to the project.

## Thanks
- The entire Android implementation is made by [andresoviedo](https://github.com/andresoviedo). I have only ported his [Android 3D Model Viewer](https://github.com/andresoviedo/android-3D-model-viewer) repo to React Native.
- Most of the ARKit implementation is taken from the [Handling 3D Interaction and UI Controls in Augmented Reality](https://developer.apple.com/documentation/arkit/handling_3d_interaction_and_ui_controls_in_augmented_reality) project made by Apple. I have only ported this project to React Native.

## License

#### The MIT License (MIT)

Copyright (c) 2017 Johan Kasperi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
