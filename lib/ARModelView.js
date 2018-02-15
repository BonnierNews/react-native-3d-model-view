import React from 'react'
import { View } from 'react-native'
import { DefaultPropTypes, ARPropTypes } from './PropTypes'
import ARManager from './ARManager'
import BaseModelView from './BaseModelView'
import RCTARModelView from './RCTARModelView'

class ARModelView extends BaseModelView {

  startAnimation () {
    ARManager.startAnimation()
  }

  stopAnimation () {
    ARManager.stopAnimation()
  }

  setProgress (value) {
    ARManager.setProgress(value)
  }

  restart () {
    ARManager.restart()
  }

  getSnapshot (saveToLibrary) {
    return ARManager.getSnapshot(saveToLibrary)
  }

  render () {
    const {modelSrc, textureSrc} = this.state
    const scale = this.props.scale || 1
    return modelSrc && textureSrc
    ? <RCTARModelView
      {...this.props}
      scale={scale}
      modelSrc={modelSrc}
      textureSrc={textureSrc}
      autoPlayAnimations={this.props.autoPlay} />
    : <View {...this.props} />
  }
}

ARModelView.propTypes = {
  ...DefaultPropTypes,
  ...ARPropTypes
}

export default ARModelView
