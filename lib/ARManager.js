import { NativeModules, Platform } from 'react-native'
import RNFS from 'react-native-fs'
import { DOCUMENTS_FOLDER } from './BaseModelView'

const IS_IOS = Platform.OS === 'ios'

const create = () => {
  const clearDownloadedFiles = () => {
    RNFS.unlink(DOCUMENTS_FOLDER)
    .then(() => {})
    .catch(() => {})
  }

  const checkIfARSupported = (callback) => {
    IS_IOS ? NativeModules['3DARModelViewManager'].checkIfARSupported(callback) : callback(false)
  }

  return {
    clearDownloadedFiles,
    checkIfARSupported
  }
}

export default create()
