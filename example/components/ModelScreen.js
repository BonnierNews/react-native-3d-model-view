import React from 'react'
import {
  StyleSheet,
  Text,
  View,
  Button
} from 'react-native'
import { ModelView } from 'react-native-3d-model-view'

export default class ModelScreen extends React.Component {
  state = {
    message: ''
  }

  modelView = null

  static navigationOptions = {
    title: 'Model'
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
    const { message } = this.state
    return <View style={styles.container}>
      <View style={styles.modelContainer}>
        <Text>{message}</Text>
        <ModelView
          ref={modelView => { this.modelView = modelView }}
          style={styles.modelView}
          source={{
            model: require('../obj/Hamburger.obj'),
            texture: require('../obj/Hamburger.png')
            // or
            // model: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.obj?raw=true',
            // texture: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.png?raw=true'
            // or
            // zip: 'https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.zip?raw=true'
            // unzippedFolderName: 'Hamburger'
            // or
            // zip: require('../obj/Hamburger.zip')
          }}
          onLoadModelStart={this.onLoadModelStart}
          onLoadModelSuccess={this.onLoadModelSuccess}
          onLoadModelError={this.onLoadModelError} />
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
  },
  buttonContainer: {
    paddingVertical: 10
  }
})
