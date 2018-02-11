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
    if (newProps.source.zip !== this.props.source.zip ||
      newProps.source.model !== this.props.source.model ||
      newProps.source.texture !== this.props.source.texture) {
      this.loadModel(newProps)
    }
  }

  loadModel = (props) => {
    console.log("loadmodelk")
    const {source} = props
    this.onLoadModelStart()
    if (source.zip) {
      let zipSource
      if (typeof source.zip === 'string' && source.zip.startsWith('http')) {
        zipSource = source.zip
      } else {
        zipSource = resolveAssetSource(source.zip).uri
      }
      if (zipSource) {
        this.fetch(zipSource)
        .then(path => {
          this.unzip(path)
          .then(unzippedPath => {
            RNFS.unlink(path)
            return `${unzippedPath}/${this.getName(zipSource)}`
          })
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
    } else {
      if (source.model) {
        let modelSource
        if (typeof source.model === 'string' && source.model.startsWith('http')) {
          modelSource = source.model
        } else {
          modelSource = resolveAssetSource(source.model).uri
        }
        if (modelSource) {
          this.fetch(modelSource)
          .then(path => {
            this.copy(path, this.getName(modelSource))
            .then(modelSrc => {
              RNFS.unlink(path)
              this.setState({modelSrc})
            })
          })
          .catch(this.onLoadModelError)
        }
      }
      if (source.texture) {
        let textureSource
        if (typeof source.texture === 'string' && source.texture.startsWith('http')) {
          textureSource = source.texture
        } else {
          textureSource = resolveAssetSource(source.texture).uri
        }
        if (textureSource) {
          this.fetch(textureSource)
          .then(path => {
            this.copy(path, this.getName(textureSource))
            .then(textureSrc => {
              RNFS.unlink(path)
              this.setState({textureSrc})
            })
          })
          .catch(this.onLoadModelError)
        }
      }
    }
  }

  onLoadModelStart = () => {
    const {onLoadModelStart} = this.props
    console.log("Start")
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
