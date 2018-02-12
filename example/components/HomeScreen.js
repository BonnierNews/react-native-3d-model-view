import React from 'react'
import { View, Button, StyleSheet } from 'react-native'
import { ARManager } from 'react-native-3d-model-view'

export default class HomeScreen extends React.Component {
  state = {
    arSupported: false
  }

  static navigationOptions = {
    title: 'Welcome!'
  }

  componentDidMount () {
    ARManager.checkIfARSupported(supported => {
      this.setState({ arSupported: supported })
    })
  }

  render () {
    const { navigate } = this.props.navigation
    return <View style={styles.container}>
      <Button onPress={() => { navigate('ModelScreen') }} title='Model screen (.obj)' />
      <Button onPress={() => { navigate('AnimatedModelScreen') }} title='Animated model screen (.dae)' />
      { this.state.arSupported ? <Button onPress={() => { navigate('ARScreen') }} title='AR model screen (.obj)' /> : null }
    </View>
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  }
})
