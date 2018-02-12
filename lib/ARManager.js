import { NativeModules, Platform } from 'react-native'
import RNFS from 'react-native-fs'
import { DOCUMENTS_FOLDER } from './BaseModelView'

const IS_IOS = Platform.OS === 'ios'
const CustomManager = NativeModules['3DARModelViewManager']

const create = () => {
  const clearDownloadedFiles = () => {
    RNFS.unlink(DOCUMENTS_FOLDER)
  }

  const reload = () => {
    IS_IOS && CustomManager.reload()
  }

  const startAnimation = () => {
    CustomManager.startAnimation()
  }

  const stopAnimation = () => {
    CustomManager.stopAnimation()
  }

  const setProgress = progress => {
    CustomManager.setProgress(progress)
  }

  const checkIfARSupported = (callback) => {
    IS_IOS ? CustomManager.checkIfARSupported(callback) : callback(false)
  }

  const restart = () => {
    IS_IOS && CustomManager.restart()
  }

  const getSnapshot = (saveToLibrary) => {
    return IS_IOS ? CustomManager.getSnapshot(saveToLibrary) : new Promise()
  }

  return {
    clearDownloadedFiles,
    reload,
    startAnimation,
    stopAnimation,
    setProgress,
    checkIfARSupported,
    restart,
    getSnapshot
  }
}

export default create()
