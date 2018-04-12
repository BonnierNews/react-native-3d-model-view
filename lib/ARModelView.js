import React from 'react'
import { View, findNodeHandle, NativeModules } from 'react-native'
import { DefaultPropTypes, ARPropTypes } from './PropTypes'
import BaseModelView from './BaseModelView'
import RCTARModelView from './RCTARModelView'

class ARModelView extends BaseModelView {

  rctView = null

  setRef = view => {
    this.rctView = view
  }

  startAnimation () {
    NativeModules['3DARModelViewManager'].startAnimation(findNodeHandle(this.rctView))
  }

  stopAnimation () {
    NativeModules['3DARModelViewManager'].stopAnimation(findNodeHandle(this.rctView))
  }

  setProgress (value) {
    let progress = value >= 1.0 ? 0.999999 : value
    progress = progress < 0.0 ? 0.0 : progress
    NativeModules['3DARModelViewManager'].setProgress(findNodeHandle(this.rctView), progress)
  }

  restart () {
    NativeModules['3DARModelViewManager'].restart(findNodeHandle(this.rctView))
  }

  getSnapshot (saveToLibrary) {
    return NativeModules['3DARModelViewManager'].getSnapshot(findNodeHandle(this.rctView), saveToLibrary)
  }

  render () {
    const {modelSrc, textureSrc} = this.state
    const scale = this.props.scale || 1
    return modelSrc && textureSrc
    ? <RCTARModelView
      {...this.props}
      ref={this.setRef}
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
