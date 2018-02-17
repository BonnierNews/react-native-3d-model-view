import React from 'react'
import { View, Button, StyleSheet } from 'react-native'
import { Manager, ARManager } from 'react-native-3d-model-view'

export default class HomeScreen extends React.Component {
  state = {
    arSupported: false
  }

  static navigationOptions = {
    title: 'Welcome!'
  }

  componentDidMount () {
    Manager.clearDownloadedFiles()
    ARManager.checkIfARSupported(supported => {
      this.setState({ arSupported: supported })
    })
  }

  render () {
    const { navigate } = this.props.navigation
    return <View style={styles.container}>
      <View style={styles.buttonContainer}>
        <Button onPress={() => { navigate('ModelScreen') }} title='Model screen (.obj)' />
      </View>
      <View style={styles.buttonContainer}>
        <Button onPress={() => { navigate('AnimatedModelScreen') }} title='Animated model screen (.dae)' />
      </View>
      { this.state.arSupported ? <View style={styles.buttonContainer}>
        <Button onPress={() => { navigate('ARScreen') }} title='AR model screen (.obj)' />
      </View> : null }
      { this.state.arSupported ? <View style={styles.buttonContainer}>
        <Button onPress={() => { navigate('AnimatedARScreen') }} title='Animated AR model screen (.dae)' />
      </View> : null }
    </View>
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  buttonContainer: {
    paddingVertical: 10
  }
})
