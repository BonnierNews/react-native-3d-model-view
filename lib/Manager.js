import RNFS from 'react-native-fs'
import { DOCUMENTS_FOLDER } from './BaseModelView'

const create = () => {
  const clearDownloadedFiles = () => {
    RNFS.unlink(DOCUMENTS_FOLDER)
    .then(() => {})
    .catch(() => {})
  }

  return {
    clearDownloadedFiles
  }
}

export default create()
