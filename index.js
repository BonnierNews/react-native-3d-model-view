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
  source: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  type: PropTypes.number.isRequired
}

const RCTModelView = requireNativeComponent('RCT3DModel', ModelView)

export default ModelView
