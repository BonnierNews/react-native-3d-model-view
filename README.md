# react-native-3d-model-view

A React Native view for displaying .obj and .scn (iOS only) models either on screen or in AR (iOS devices with A9 or later processors only).

**Example Project**: https://github.com/BonnierNews/react-native-3d-model-view/tree/master/example

**Note**: Currently only supports iOS (Android coming soon).

## Getting started

`$ yarn add react-native-3d-model-view`

and then

`$ react-native link react-3d-model-view`

The lib also have peer dependencies of `react-native-zip-archive`, `react-native-fetch-blob` and `react-native-fs`. Make sure that you `yarn add` and `react-native link` them to.

## Usage

### Model view
```javascript
import ModelView, { ModelTypes } from 'react-native-3d-model-view'

<ModelView
  source={{ uri: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.zip?raw=true' }}
  type={ModelTypes.OBJ}
  onLoadModelStart={this.onLoadModelStart}
  onLoadModelSuccess={this.onLoadModelSuccess}
  onLoadModelError={this.onLoadModelError} />

```
<img src="screenshots/modelview.png" width="250">

### AR Model view
```javascript
import ARModelView, { ModelTypes } from 'react-native-3d-model-view'

<ARModelView
  source={{ uri: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.zip?raw=true' }}
  type={ModelTypes.OBJ}
  scale={0.1}
  focusSquareColor='red'
  focusSquareFillColor='blue'
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

<img src="screenshots/arview.png" width="250">

## Components

### ModelView

View for displaying .obj or .scn (iOS only) on screen with SceneKit or OpenGL.

#### Props
| Prop | Type | Default | Note |
|---|---|---|---|
|`source`|`string` or `object`|`null`|Can be either a `string` with a local path or an `object` with prop `uri` if you want to fetch it from a server. Also please note that the source can be a .zip containing the object and the texture.|
|`type`|`ModelTypes`|`null`|Import `ModelTypes` and select the file type of your model|
|`color`|`string`|`null`|Desired color of the model.|
|`scale`|`number`|`1`|Scale of the model.|

#### Events
| Event Name | Returns | Notes |
|---|---|---|
|`onLoadModelStart`|`null`|Loading model has started.|
|`onLoadModelSuccess`|`null`|Loading model has succeeded.|
|`onLoadModelError`|`Error`|Failed loading model.|

#### Methods
Use `ref={modelView => {this.modelView = modelView}}` to be able to call the methods listed below.

| Method Name | Returns | Notes |
|---|---|---|
|`reload`|`null`|Reloads the model.|

### ARModelView

View for displaying .obj or .scn in augmented reality (iOS devices with A9 or later processors only).

#### Props
| Prop | Type | Default | Note |
|---|---|---|---|
|`source`|`string` or `object`|`null`|Can be either a `string` with a local path or an `object` with prop `uri` if you want to fetch it from a server. Also please note that the source can be a .zip containing the object and the texture.|
|`type`|`ModelTypes`|`null`|Import `ModelTypes` and select the file type of your model|
|`color`|`string`|`null`|Desired color of the model.|
|`scale`|`number`|`1`|Scale of the model.|
|`focusSquareColor`|`string`|`#FFCC00`|Color of the segments in the focus square.|
|`focusSquareFillColor`|`string`|`#FFEC69`|Fill color of the focus square.|

#### Events
| Event Name | Returns | Notes |
|---|---|---|
|`onLoadModelStart`|`null`|Loading model has started.|
|`onLoadModelSuccess`|`null`|Loading model has succeeded.|
|`onLoadModelError`|`Error`|Failed loading model.|
|`onStart`|`null`||
|`onSurfaceFound`|`null`||
|`onSurfaceLost`|`null`||
|`onSessionInterupted`|`null`||
|`onSessionInteruptedEnded`|`null`||
|`onPlaceObjectSuccess`|`null`||
|`onPlaceObjectError`|`null`||
|`onTrackingQualityInfo`|`{id: number, presentation: string, recommendation: string`|The current info about the tracking quality.|

#### Methods
Use `ref={arView => {this.arView = arView}}` to be able to call the methods listed below.

| Method Name | Returns | Notes |
|---|---|---|
|`reload`|`null`|Reloads the model.|
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

## License

#### The MIT License (MIT)

Copyright (c) 2017 Johan Kasperi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
