import { ViewPropTypes, ColorPropType } from 'react-native'
import PropTypes from 'prop-types'

export const DefaultPropTypes = {
  ...ViewPropTypes,
  source: PropTypes.object,
  scale: PropTypes.number,
  onLoadModelStart: PropTypes.func,
  onLoadModelSuccess: PropTypes.func,
  onLoadModelError: PropTypes.func
}

export const RCTPropTypes = {
  ...ViewPropTypes,
  modelSrc: PropTypes.string,
  textureSrc: PropTypes.string,
  scale: PropTypes.number,
  loadModelSuccess: PropTypes.func,
  loadModelError: PropTypes.func
}

export const ARPropTypes = {
  focusSquareColor: ColorPropType,
  focusSquareFillColor: ColorPropType,
  onStart: PropTypes.func,
  onSurfaceFound: PropTypes.func,
  onSurfaceLost: PropTypes.func,
  onSessionInterupted: PropTypes.func,
  onSessionInteruptedEnded: PropTypes.func,
  onPlaceObjectSuccess: PropTypes.func,
  onPlaceObjectError: PropTypes.func,
  onTrackingQualityInfo: PropTypes.func
}
