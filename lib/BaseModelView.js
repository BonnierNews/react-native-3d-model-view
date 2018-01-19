import React from 'react'
import RNFetchBlob from 'react-native-fetch-blob'
import RNFS, { DocumentDirectoryPath } from 'react-native-fs'
import { unzip } from 'react-native-zip-archive'
import { DefaultPropTypes } from './PropTypes'

export const DOCUMENTS_FOLDER = `${DocumentDirectoryPath}/rct-3d-model-view`

class BaseModelView extends React.Component {
  state = {
    src: null
  }

  componentDidMount () {
    this.loadModel(this.props)
  }

  componentWillReceiveProps(newProps) {
    if (newProps.source.uri !== this.props.source.uri || (!newProps.source.uri && newProps.source !== this.props.source)) {
      this.loadModel(newProps)
    }
  }

  loadModel = (props) => {
    const {source} = props
    this.onLoadModelStart()
    if (source.uri) {
      this.fetch(source.uri)
      .then(path => {
        if (source.uri.indexOf('.zip') !== -1) {
          this.unzip(path)
          .then(src => {
            this.setState({src})
          })
          .catch(this.onLoadModelError)
        } else {
          this.copy(path)
          .then(src => {
            this.setState({src})
          })
          .catch(this.onLoadModelError)
        }
      })
      .catch(this.onLoadModelError)
    } else {
      this.setState({src: source})
    }
  }

  onLoadModelStart = () => {
    const {onLoadModelStart} = this.props
    onLoadModelStart && onLoadModelStart()
  }

  onLoadModelSuccess = () => {
    const {onLoadModelSuccess} = this.props
    onLoadModelSuccess && onLoadModelSuccess()
  }

  onLoadModelError = (error) => {
    const {onLoadModelError} = this.props
    onLoadModelError && onLoadModelError(error)
  }

  fetch (uri) {
    return RNFetchBlob
    .config({
      fileCache : true
    })
    .fetch('GET', uri, {})
    .then(res => res.path())
  }

  unzip (path) {
    return RNFS.mkdir(DOCUMENTS_FOLDER)
    .then(() => {
      return unzip(path, DOCUMENTS_FOLDER)
      .then(unzippedPath => `${unzippedPath}/${this.getName()}`)
    })
  }

  copy (path) {
    const targetPath = `${DOCUMENTS_FOLDER}/${this.getName()}`
    return RNFS.mkdir(DOCUMENTS_FOLDER)
    .then(() => {
      return RNFS.unlink(targetPath)
      .then(() => {
        return RNFS.copyFile(path, targetPath)
        .then(() => targetPath)
      })
      .catch((err) => {
        return RNFS.copyFile(path, targetPath)
        .then(() => targetPath)
      })
    })
  }

  getName = () => {
    const {source} = this.props
    let name
    if (source.uri) {
      name = source.uri.split('/').pop()
    } else {
      name = source.split('/').pop()
    }
    name = name.indexOf('.zip') !== -1 ? name.replace('.zip', '') : name
    name = name.indexOf('?') !== -1 ? name.substring(0, name.indexOf('?')) : name
    return name
  }
}

export default BaseModelView
