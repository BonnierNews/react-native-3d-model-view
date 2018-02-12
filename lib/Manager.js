import { NativeModules, Platform, UIManager, findNodeHandle } from 'react-native'
import RNFS from 'react-native-fs'
import { DOCUMENTS_FOLDER } from './BaseModelView'

const IS_IOS = Platform.OS === 'ios'
const CustomManager = NativeModules['3DScnModelViewManager']

const create = () => {
  const clearDownloadedFiles = () => {
    RNFS.unlink(DOCUMENTS_FOLDER)
  }

  const reload = () => {
    if (IS_IOS) {
      CustomManager.reload()
    }
  }

  const startAnimation = () => {
    if (IS_IOS) {
      CustomManager.startAnimation()
    } else {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this),
        UIManager.RCT3DScnModelView.Commands.startAnimation,
        [1]
      )
    }
  }

  const stopAnimation = () => {
    if (IS_IOS) {
      CustomManager.stopAnimation()
    } else {
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this),
        UIManager.RCT3DScnModelView.Commands.stopAnimation,
        [1]
      )
    }
  }

  const setProgress = progress => {
    if (IS_IOS) {
      CustomManager.setProgress(progress)
    }
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
