import { NativeModules } from 'react-native'
import RNFS from 'react-native-fs'
import { DOCUMENTS_FOLDER } from './BaseModelView'

const CustomManager = NativeModules['3DScnModelViewManager']

const create = () => {
  const clearDownloadedFiles = () => {
    RNFS.unlink(DOCUMENTS_FOLDER)
  }

  const reload = () => {
    CustomManager.reload()
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

  return {
    clearDownloadedFiles,
    reload,
    startAnimation,
    stopAnimation,
    setProgress
  }
}

export default create()
