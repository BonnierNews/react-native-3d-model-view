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
import {ARModelView, ModelView, ModelTypes} from 'react-native-3d-model-view'

export default class App extends React.Component {
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
      <ModelView
        style={styles.modelView}
        source='art.scnassets/jonas/Jonas_2.scn'
        name='Jonas_2'
        type={ModelTypes.SCN}
        scale={1}
        // color={'#FF0000'}
        focusSquareColor='red'
        focusSquareFillColor='black'
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
  },
  modelView: {
    width: '100%',
    height: 300,
    backgroundColor: 'white',
    margin: 10
  }
})
