import React from 'react'
import { Platform } from 'react-native'
import RNFetchBlob from 'rn-fetch-blob'
import RNFS, { DocumentDirectoryPath } from 'react-native-fs'
import { unzip } from 'react-native-zip-archive'
import { DefaultPropTypes } from './PropTypes'
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource'

export const DOCUMENTS_FOLDER = `${DocumentDirectoryPath}/rct-3d-model-view`

const ACCEPTED_MODEL_TYPES = Platform.OS === 'ios' ? ['.dae', '.obj', '.scn'] : ['.dae', '.obj']
const ACCEPTED_TEXTURE_TYPES = ['.png', '.jpg']

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
    const {source, onLoadModelStart} = props
    onLoadModelStart && onLoadModelStart()
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
          .then(modelSrc => {
            this.setState({modelSrc})
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
          .then(textureSrc => {
            this.setState({textureSrc})
          })
          .catch(this.onLoadModelError)
        }
      }
    }
  }

  fetch (uri) {
    return RNFS.mkdir(DOCUMENTS_FOLDER)
    .then(() => {
      const name = this.getName(uri)
      const targetPath = `${DOCUMENTS_FOLDER}/${name}`
      return RNFS.exists(targetPath)
      .then(exists => {
        if (exists) {
          return targetPath
        } else {
          return RNFetchBlob
          .config({
            fileCache: true,
            path: targetPath
          })
          .fetch('GET', uri, {})
          .then(res => res.path())
        }
      })
    })
  }

  unzip (path) {
    return unzip(path, DOCUMENTS_FOLDER)
    .then(unzippedPath => {
      let name
      if (this.props.source.unzippedFolderName) {
        name = this.props.source.unzippedFolderName
      } else {
        name = this.getName(path)
        name = name.includes('.zip') ? name.replace('.zip', '') : name
      }
      return `${unzippedPath}/${name}`
    })
  }

  getName = (source) => {
    let name = source.split('/').pop()
    name = name.includes('?') ? name.substring(0, name.indexOf('?')) : name
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
      return file ? file.path : null
    })
  }
}

export default BaseModelView
