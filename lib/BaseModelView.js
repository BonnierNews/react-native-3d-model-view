import React from 'react'
import { Platform } from 'react-native'
import RNFetchBlob from 'react-native-fetch-blob'
import RNFS, { DocumentDirectoryPath } from 'react-native-fs'
import { unzip } from 'react-native-zip-archive'
import { DefaultPropTypes } from './PropTypes'
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource'

export const DOCUMENTS_FOLDER = `${DocumentDirectoryPath}/rct-3d-model-view`

const ACCEPTED_MODEL_TYPES = Platform.OS === 'ios' ? ['.dae', '.obj', '.scn'] : ['.dae', '.obj']
const ACCEPTED_TEXTURE_TYPES = ['.png']

class BaseModelView extends React.Component {
  state = {
    modelSrc: null,
    textureSrc: null
  }

  componentDidMount () {
    this.loadModel(this.props)
  }

  componentWillReceiveProps(newProps) {
    // if (newProps.source !== this.props.source) {
    //   this.loadModel(newProps)
    // }
  }

  loadModel = (props) => {
    const {source} = props
    this.onLoadModelStart()
    if (source.zip) {
      if (!source.zip.startsWith('http')) {
        console.warn('[react-native-3d-model-view]', 'zip source needs to be http')
        return
      }
      this.fetch(source.zip)
      .then(path => {
        this.unzip(path)
        .then(unzippedPath => `${unzippedPath}/${this.getName(source.zip)}`)
        .then(src => {
          this.getFirstFileTypeInFolder(src, ACCEPTED_MODEL_TYPES)
          .then(modelSrc => { this.setState({modelSrc}) })
          .catch(this.onLoadModelError)
          this.getFirstFileTypeInFolder(src, ACCEPTED_TEXTURE_TYPES)
          .then(textureSrc => { this.setState({textureSrc}) })
          .catch(this.onLoadModelError)
        })
        .catch(this.onLoadModelError)
      })
      .catch(this.onLoadModelError)
    }
    if (source.model) {
      if (typeof source.model === 'string' && source.model.startsWith('http')) {
        this.fetch(source.model)
        .then(path => {
          this.copy(path, this.getName(source.model))
          .then(modelSrc => {
            this.setState({modelSrc})
          })
        })
        .catch(this.onLoadModelError)
      } else {
        this.setState({modelSrc: resolveAssetSource(source.model).uri})
      }
    }
    if (source.texture) {
      if (typeof source.texture === 'string' && source.texture.startsWith('http')) {
        this.fetch(source.texture)
        .then(path => {
          this.copy(path, this.getName(source.texture))
          .then(textureSrc => {
            this.setState({textureSrc})
          })
        })
        .catch(this.onLoadModelError)
      } else {
        this.setState({textureSrc: resolveAssetSource(source.texture).uri})
      }
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
    })
  }

  copy (path, name) {
    const targetPath = `${DOCUMENTS_FOLDER}/${name}`
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

  getName = (source) => {
    let name = source.split('/').pop()
    name = name.indexOf('.zip') !== -1 ? name.replace('.zip', '') : name
    name = name.indexOf('?') !== -1 ? name.substring(0, name.indexOf('?')) : name
    return name
  }

  getFirstFileTypeInFolder = (folder, acceptedFileTypes) => {
    return RNFS.readDir(folder)
    .then((result) => {
      const file = result.find(element => {
        for (let i = 0; i < acceptedFileTypes.length; i++) {
          if (element.path.endsWith(acceptedFileTypes[i])) {
            return true
          }
        }
        return false
      })
      return file.path
    })
  }
}

export default BaseModelView
