import React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes
} from 'react-native'
import PropTypes from 'prop-types'

class ModelView extends React.Component {
  render () {
    return <RCTModelView {...this.props} />
  }
}

ModelView.propTypes = {
  ...ViewPropTypes,
  source: PropTypes.object.isRequired
}

const RCTModelView = requireNativeComponent('RCT3DModel', ModelView)

export default ModelView
