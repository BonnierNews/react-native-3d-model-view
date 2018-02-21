import React from 'react'
import { View, StyleSheet, Platform, UIManager, findNodeHandle } from 'react-native'
import { DefaultPropTypes } from './PropTypes'
import Manager from './Manager'
import RCTScnModelView from './RCTScnModelView'
import BaseModelView from './BaseModelView'

const IS_IOS = Platform.OS === 'ios'

class ModelView extends BaseModelView {

  startAnimation () {
    if (IS_IOS) {
      Manager.startAnimation()
    } else {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this),
        UIManager.RCT3DScnModelView.Commands.startAnimation,
        []
      )
    }
  }

  stopAnimation () {
    if (IS_IOS) {
      Manager.stopAnimation()
    } else {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this),
        UIManager.RCT3DScnModelView.Commands.stopAnimation,
        []
      )
    }
  }

  setProgress (value) {
    let progress = value >= 1.0 ? 0.999999 : value
    progress = progress < 0.0 ? 0.0 : progress
    if (IS_IOS) {
      Manager.setProgress(progress)
    } else {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this),
        UIManager.RCT3DScnModelView.Commands.setProgress,
        [progress]
      )
    }
  }

  renderIOS = () => {
    const {modelSrc, textureSrc} = this.state
    const scale = this.props.scale || 1
    return <RCTScnModelView
      {...this.props}
      scale={scale}
      modelSrc={modelSrc}
      textureSrc={textureSrc}
      autoPlayAnimations={this.props.autoPlay} />
  }

  renderAndroid = () => {
    const {modelSrc, textureSrc} = this.state
    const scale = this.props.scale || 1
    return <View style={this.props.style}>
      <RCTScnModelView
        {...this.props}
        scale={scale * 3}
        modelSrc={modelSrc}
        textureSrc={textureSrc}
        backgroundColor={StyleSheet.flatten(this.props.style).backgroundColor || 'white'}
        autoPlayAnimations={this.props.autoPlay} />
      <View style={{position: 'absolute', top: 0, right: 0, bottom: 0, left: 0}} pointerEvents='box-none'>
        {this.props.children}
      </View>
    </View>
  }

  render () {
    const {modelSrc, textureSrc} = this.state
    return modelSrc && textureSrc
    ? (Platform.OS === 'ios' ? this.renderIOS() : this.renderAndroid())
    : <View {...this.props} />
  }
}

ModelView.propTypes = DefaultPropTypes

export default ModelView
