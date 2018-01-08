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
import ModelView, {ModelTypes} from 'react-native-3d-model-view'

export default class App extends React.Component {
  render () {
    return <View style={styles.container}>
      <Text style={styles.welcome}>
        Welcome to React Native 3D model view!
      </Text>
      <ModelView
        style={{width: 300, height: 300, backgroundColor: 'white'}}
        source='http://localhost:8000/V_Jonas1-7.zip'
        name='Jonas_1'
        type={ModelTypes.OBJ}
        onLoadModelStart={() => { console.log("start") }}
        onLoadModelSuccess={() => { console.log("sucess") }} />
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
