import { ViewPropTypes, ColorPropType } from 'react-native'
import PropTypes from 'prop-types'

export const DefaultPropTypes = {
  ...ViewPropTypes,
  source: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.obj
  ]),
  type: PropTypes.number,
  color: ColorPropType,
  scale: PropTypes.number,
  onLoadModelStart: PropTypes.func,
  onLoadModelSuccess: PropTypes.func,
  onLoadModelError: PropTypes.func
}

export const RCTPropTypes = {
  ...ViewPropTypes,
  src: PropTypes.string,
  type: PropTypes.number,
  color: ColorPropType,
  scale: PropTypes.number,
  loadModelSuccess: PropTypes.func,
  loadModelError: PropTypes.func
}
