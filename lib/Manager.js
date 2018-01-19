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

  return {
    clearDownloadedFiles,
    reload
  }
}

export default create()
