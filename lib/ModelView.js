import React from 'react'
import { View, StyleSheet } from 'react-native'
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

    return modelSrc && textureSrc
    ? <RCTScnModelView
      {...this.props}
      modelSrc={modelSrc}
      textureSrc={textureSrc}
      backgroundColor={StyleSheet.flatten(this.props.style).backgroundColor || 'white'}
      loadModelSuccess={this.onLoadModelSuccess}
      loadModelError={this.onLoadModelError} />
    : <View {...this.props} />
  }
}

ModelView.propTypes = DefaultPropTypes

export default ModelView
