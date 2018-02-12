import React from 'react'
import {
  StyleSheet,
  Text,
  View,
  Button,
  Platform,
  Slider
} from 'react-native'
import { ModelView } from 'react-native-3d-model-view'

export default class AnimatedModelScreen extends React.Component {
  state = {
    message: '',
    isPlaying: false
  }

  modelView = null

  static navigationOptions = {
    title: 'Animated model'
  }

  togglePlay = () => {
    const { isPlaying } = this.state
    isPlaying ? this.modelView.stopAnimation() : this.modelView.startAnimation()
    this.setState({isPlaying: !isPlaying})
  }

  sliderValueChange = value => {
    const { isPlaying } = this.state
    if (isPlaying) {
      this.togglePlay()
    }
    this.modelView.setProgress(value)
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

  render () {
    const { navigate } = this.props.navigation
    const { message, isPlaying } = this.state
    return <View style={styles.container}>
      <View style={styles.modelContainer}>
        <Text>{message}</Text>
        <ModelView
          ref={modelView => { this.modelView = modelView }}
          style={styles.modelView}
          source={{
            model: Platform.OS === 'ios' ? require('../obj/Stormtrooper_ios.dae') : require('../obj/Stormtrooper.dae'),
            texture: require('../obj/Stormtrooper.jpg')
          }}
          autoPlay={isPlaying}
          onLoadModelStart={this.onLoadModelStart}
          onLoadModelSuccess={this.onLoadModelSuccess}
          onLoadModelError={this.onLoadModelError} />
          <Button onPress={this.togglePlay} title={isPlaying ? 'Stop' : 'Play' } />
          <Text>Progress</Text>
          <Slider maximumValue={1} minimumValue={0} onValueChange={this.sliderValueChange} />
      </View>
    </View>
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  },
  modelContainer: {
    padding: 10,
    width: '100%'
  },
  modelView: {
    width: '100%',
    height: 300,
    backgroundColor: 'white'
  }
})
