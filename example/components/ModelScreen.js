import React from 'react'
import {
  StyleSheet,
  Text,
  View,
  Button
} from 'react-native'
import { ModelView, ARManager } from 'react-native-3d-model-view'

export default class ModelScreen extends React.Component {
  state = {
    arSupported: false,
    message: ''
  }

  static navigationOptions = {
    title: 'Welcome!'
  }

  componentDidMount () {
    ARManager.checkIfARSupported(supported => {
      this.setState({ arSupported: supported })
    })
  }

  onLoadModelStart = () => {
    this.setState({ message: 'Loading model...'})
    console.log('[react-native-3d-model-view]:', 'Load model start.')
  }

  onLoadModelSuccess = () => {
    this.setState({ message: 'Loading model success!'})
    console.log('[react-native-3d-model-view]:', 'Load model success.')
  }

  onLoadModelError = () => {
    this.setState({ message: 'Loading model error :('})
    console.log('[react-native-3d-model-view]:', 'Load model error.')
  }

  render () {
    const { navigate } = this.props.navigation
    const { arSupported, message } = this.state
    return <View style={styles.container}>
      <View style={styles.modelContainer}>
        <Text>{message}</Text>
        <ModelView
          style={styles.modelView}
          source={{
            model: require('../obj/Hamburger.obj'),
            texture: require('../obj/Hamburger.png')
          }}
          onLoadModelStart={this.onLoadModelStart}
          onLoadModelSuccess={this.onLoadModelSuccess}
          onLoadModelError={this.onLoadModelError} />
        { arSupported
          ? <Button
            onPress={() => { navigate('ARScreen') }}
            title="Open in AR"
          />
          : null
        }
      </View>
    </View>
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF'
  },
  modelContainer: {
    padding: 10,
    width: '100%'
  },
  modelView: {
    width: '100%',
    height: 300
  }
})
