import { NativeModules } from 'react-native'
import RNFS from 'react-native-fs'
import { DOCUMENTS_FOLDER } from './BaseModelView'

const CustomManager = NativeModules['3DARModelViewManager']

const create = () => {
  const clearDownloadedFiles = () => {
    RNFS.unlink(DOCUMENTS_FOLDER)
  }

  const reload = () => {
    CustomManager.reload()
  }

  const checkIfARSupported = (callback) => {
    CustomManager.checkIfARSupported(callback)
  }

  const restart = () => {
    CustomManager.restart()
  }

  const getSnapshot = (saveToLibrary) => {
    return CustomManager.getSnapshot(saveToLibrary)
  }

  return {
    clearDownloadedFiles,
    reload,
    checkIfARSupported,
    restart,
    getSnapshot
  }
}

export default create()
