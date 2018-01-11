import React from 'react'
import {
  StyleSheet,
  Text,
  View
} from 'react-native'
import {ARModelView, ModelTypes} from 'react-native-3d-model-view'

export default class ARScreen extends React.Component {
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
      <ARModelView
        style={styles.modelView}
        source='art.scnassets/teapot.obj'
        name='Jonas_2'
        type={ModelTypes.SCN}
        scale={1}
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
  modelView: {
    width: '100%',
    flex: 1
  }
})
