import {
  StackNavigator
} from 'react-navigation'
import HomeScreen from './HomeScreen'
import ModelScreen from './ModelScreen'
import AnimatedModelScreen from './AnimatedModelScreen'
import ARScreen from './ARScreen'

const App = StackNavigator({
  HomeScreen: { screen: HomeScreen },
  ModelScreen: { screen: ModelScreen },
  AnimatedModelScreen: { screen: AnimatedModelScreen },
  ARScreen: { screen: ARScreen }
})

export default App
