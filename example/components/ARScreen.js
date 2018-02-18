import React from 'react'
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity
} from 'react-native'
import {ARModelView, ModelTypes} from 'react-native-3d-model-view'

export default class ARScreen extends React.Component {
  state = {
    message: ''
  }

  arView = null

  snapshot = () => {
    this.arView.getSnapshot(false)
    .then(event => console.log(event))
    .catch(error => console.log(error))
  }

  onLoadModelStart = () => {
    console.log('[react-native-3d-model-view]:', 'Load model start.')
  }

  onLoadModelSuccess = () => {
    console.log('[react-native-3d-model-view]:', 'Load model success.')
  }

  onLoadModelError = () => {
    console.log('[react-native-3d-model-view]:', 'Load model error.')
  }

  onStart = () => {
    console.log('[react-native-3d-model-view]:', 'AR - Session started.')
  }

  onSurfaceFound = () => {
    console.log('[react-native-3d-model-view]:', 'AR - Planar surface found.')
  }

  onSurfaceLost = () => {
    console.log('[react-native-3d-model-view]:', 'AR - Planar surface lost.')
  }

  onSessionInterupted = () => {
    console.log('[react-native-3d-model-view]:', 'AR - Session interupted.')
  }

  onSessionInteruptedEnded = () => {
    console.log('[react-native-3d-model-view]:', 'AR - Session interupted ended.')
  }

  onPlaceObjectSuccess = () => {
    console.log('[react-native-3d-model-view]:', 'AR - Place object success!')
  }

  onPlaceObjectError = () => {
    console.log('[react-native-3d-model-view]:', 'AR - Place object error.')
  }

  onTrackingQualityInfo = (event) => {
    this.setState({ message: event.nativeEvent.presentation })
    console.log('[react-native-3d-model-view]:', 'AR -', event.nativeEvent.id, event.nativeEvent.presentation, event.nativeEvent.recommendation)
  }

  render () {
    const {message} = this.state
    return <View style={styles.container}>
      <ARModelView
        ref={arView => { this.arView = arView }}
        style={styles.modelView}
        source={{ zip: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.zip?raw=true' }}
        scale={0.1}
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
      <Text style={[styles.controlItem, styles.message]}>{message}</Text>
      <TouchableOpacity onPress={() => { this.arView.restart() }} style={styles.restartButton}>
        <Text style={styles.controlItem}>Restart</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={this.snapshot} style={styles.photoButton}>
        <Text style={styles.controlItem}>Take photo</Text>
      </TouchableOpacity>
    </View>
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5FCFF'
  },
  modelView: {
    width: '100%',
    flex: 1
  },
  controlItem: {
    color: 'black',
    backgroundColor: '#eee',
    textAlign: 'center',
    fontSize: 14,
    padding: 10
  },
  message: {
    position: 'absolute',
    top: 20,
    left: 20,
  },
  restartButton: {
    position: 'absolute',
    top: 20,
    right: 20
  },
  photoButton: {
    position: 'absolute',
    bottom: 20,
    right: 20,
    left: 20
  }
})
