/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React from 'react'
import {
  StyleSheet,
  Text,
  View
} from 'react-native'
import {ARModelView, ModelView, Manager, ModelTypes} from 'react-native-3d-model-view'

export default class App extends React.Component {
  componentDidMount () {
    Manager.checkIfARSupported(supported => {
      console.log(supported)
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
    return <View style={styles.container}>
      <Text style={styles.welcome}>
        Welcome to React Native 3D model view!
      </Text>
      <ARModelView
        style={{flex: 1, width: '100%'}}
        source='art.scnassets/jonas/Jonas_2.scn'
        name='Jonas_2'
        type={ModelTypes.SCN}
        onLoadModelStart={this.onLoadModelStart}
        onLoadModelSuccess={this.onLoadModelSuccess}
        onLoadModelError={this.onLoadModelError} />
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
  }
})
