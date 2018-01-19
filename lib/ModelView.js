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
    const {src} = this.state
    return src
    ? <RCTScnModelView
      {...this.props}
      src={src}
      loadModelSuccess={this.onLoadModelSuccess}
      loadModelError={this.onLoadModelError} />
    : <View {...this.props} />
  }
}

ModelView.propTypes = DefaultPropTypes

export default ModelView
