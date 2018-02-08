import React from 'react'
import { View } from 'react-native'
import { DefaultPropTypes } from './PropTypes'
import Manager from './Manager'
import RCTScnModelView from './RCTScnModelView'
import BaseModelView from './BaseModelView'

class ModelView extends BaseModelView {
  reload () {
    Manager.reload()
  }

  render () {
    const {modelSrc, textureSrc} = this.state
    console.log(modelSrc, textureSrc)
    return modelSrc && textureSrc
    ? <RCTScnModelView
      {...this.props}
      modelSrc={modelSrc}
      textureSrc={textureSrc}
      loadModelSuccess={this.onLoadModelSuccess}
      loadModelError={this.onLoadModelError} />
    : <View {...this.props} />
  }
}

ModelView.propTypes = DefaultPropTypes

export default ModelView
