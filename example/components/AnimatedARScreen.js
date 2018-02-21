import React from 'react'
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Platform,
  Slider,
  Switch
} from 'react-native'
import { ARModelView } from 'react-native-3d-model-view'

export default class AnimatedARScreen extends React.Component {
  state = {
    message: '',
    isPlaying: false,
    animationProgress: 0,
    miniature: false
  }

  arView = null

  static navigationOptions = {
    title: 'Animated model'
  }

  togglePlay = () => {
    const { isPlaying } = this.state
    isPlaying ? this.arView.stopAnimation() : this.arView.startAnimation()
  }

  sliderValueChange = value => {
    const { isPlaying } = this.state
    this.arView.setProgress(value)
  }

  miniatureChange = value => {
    this.setState({miniature: value})
  }

  snapshot = () => {
    this.arView.getSnapshot(true)
    .then(event => console.log(event))
    .catch(error => console.log(error))
  }

  onLoadModelStart = () => {
    this.setState({ message: 'Loading model...'})
    console.log('[react-native-3d-model-view]:', 'Load model start.')
  }

  onLoadModelSuccess = () => {
    this.setState({ message: 'Loading model success!'})
    console.log('[react-native-3d-model-view]:', 'Load model success.')
  }

  onLoadModelError = (error) => {
    this.setState({ message: 'Loading model error :('})
    console.log('[react-native-3d-model-view]:', 'Load model error.')
  }

  onAnimationStart = () => {
    this.setState({isPlaying: true})
  }

  onAnimationStop = () => {
    this.setState({isPlaying: false})
  }

  onAnimationUpdate = event => {
    this.setState({animationProgress: event.nativeEvent.progress})
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
    const { navigate } = this.props.navigation
    const { message, isPlaying, animationProgress, miniature } = this.state
    return <View style={styles.container}>
      <ARModelView
        ref={arView => { this.arView = arView }}
        style={styles.modelView}
        source={{
          model: Platform.OS === 'ios' ? require('../obj/Stormtrooper_ios.dae') : require('../obj/Stormtrooper.dae'),
          texture: require('../obj/Stormtrooper.jpg')
        }}
        miniature={miniature}
        miniatureScale={0.1}
        placeOpacity={0.1}
        onLoadModelStart={this.onLoadModelStart}
        onLoadModelSuccess={this.onLoadModelSuccess}
        onLoadModelError={this.onLoadModelError}
        onAnimationStart={this.onAnimationStart}
        onAnimationStop={this.onAnimationStop}
        onStart={this.onStart}
        onSurfaceFound={this.onSurfaceFound}
        onSurfaceLost={this.onSurfaceLost}
        onSessionInterupted={this.onSessionInterupted}
        onSessionInteruptedEnded={this.onSessionInteruptedEnded}
        onPlaceObjectSuccess={this.onPlaceObjectSuccess}
        onPlaceObjectError={this.onPlaceObjectError}
        onTrackingQualityInfo={this.onTrackingQualityInfo}
        onAnimationUpdate={this.onAnimationUpdate} />
      <Text style={[styles.controlItem, styles.message]}>{message}</Text>
      <View style={styles.miniatureSwitch}>
        <Text>Miniature</Text>
        <Switch onValueChange={this.miniatureChange} value={miniature} />
      </View>
      <TouchableOpacity onPress={() => { this.arView.restart() }} style={styles.restartButton}>
        <Text style={styles.controlItem}>Restart</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={this.snapshot} style={styles.photoButton}>
        <Text style={styles.controlItem}>Take photo</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={this.togglePlay} style={styles.playPauseButton}>
        <Text style={styles.controlItem}>{isPlaying ? 'Stop' : 'Play' }</Text>
      </TouchableOpacity>
      <Slider style={styles.slider} maximumValue={1} minimumValue={0} value={animationProgress} onValueChange={this.sliderValueChange} />
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
    bottom: 120,
    right: 20,
    left: 20
  },
  playPauseButton: {
    position: 'absolute',
    bottom: 70,
    right: 20,
    left: 20
  },
  slider: {
    position: 'absolute',
    bottom: 20,
    right: 20,
    left: 20
  },
  miniatureSwitch: {
    position: 'absolute',
    top: 60,
    left: 20
  }
})
