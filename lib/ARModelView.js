import React from 'react'
import { View } from 'react-native'
import { DefaultPropTypes, ARPropTypes } from './PropTypes'
import ARManager from './ARManager'
import BaseModelView from './BaseModelView'
import RCTARModelView from './RCTARModelView'

class ARModelView extends BaseModelView {
  reload () {
    ARManager.reload()
  }

  restart () {
    ARManager.restart()
  }

  getSnapshot (saveToLibrary) {
    return ARManager.getSnapshot(saveToLibrary)
  }

  render () {
    const {src} = this.state
    return src
    ? <RCTARModelView
      {...this.props}
      src={src}
      loadModelSuccess={this.onLoadModelSuccess}
      loadModelError={this.onLoadModelError} />
    : <View {...this.props} />
  }
}

ARModelView.propTypes = {
  ...DefaultPropTypes,
  ...ARPropTypes
}

export default ARModelView
