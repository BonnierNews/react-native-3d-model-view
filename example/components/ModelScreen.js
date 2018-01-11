import React from 'react'
import {
  StyleSheet,
  Text,
  View,
  Button
} from 'react-native'
import { ModelView, ModelTypes, ARManager } from 'react-native-3d-model-view'

export default class ModelScreen extends React.Component {
  state = {
    arSupported: false
  }

  static navigationOptions = {
    title: 'Home'
  }

  componentDidMount () {
    ARManager.checkIfARSupported(supported => {
      this.setState({ arSupported: true })
    })
  }

  onLoadModelStart () {
    console.log('[react-native-3d-model-view]:', 'Load model start.')
  }

  onLoadModelSuccess () {
    console.log('[react-native-3d-model-view]:', 'Load model success.')
  }

  onLoadModelError () {
    console.log('[react-native-3d-model-view]:', 'Load model error.')
  }

  render () {
    const { navigate } = this.props.navigation
    const { arSupported } = this.state

    return <View style={styles.container}>
      <Text style={styles.welcome}>
        Welcome to React Native 3D model view!
      </Text>
      <View style={styles.modelContainer}>
        <ModelView
          style={styles.modelView}
          source='https://github.com/BonnierNews/react-native-3d-model-view/blob/master/example/obj/Hamburger.zip?raw=true'
          type={ModelTypes.OBJ}
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
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10
  },
  modelContainer: {
    padding: 10,
    width: '100%'
  },
  modelView: {
    backgroundColor: 'white',
    width: '100%',
    height: 300
  }
})
