import React from 'react'
import { View, StyleSheet, Platform } from 'react-native'
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
    const scale = this.props.scale || 1
    return modelSrc && textureSrc
    ? <RCTScnModelView
      {...this.props}
      scale={Platform.OS === 'ios' ? scale : scale * 7}
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
