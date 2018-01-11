import {
  StackNavigator
} from 'react-navigation'
import ModelScreen from './ModelScreen'
import ARScreen from './ARScreen'

const App = StackNavigator({
  ModelScreen: { screen: ModelScreen },
  ARScreen: { screen: ARScreen }
})

export default App
