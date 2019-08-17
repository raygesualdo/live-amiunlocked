import { Socket } from 'phoenix'
import { updateUi, resetUi } from './ui'

const socket = new Socket('/socket')
socket.connect()

const channel = socket.channel('state', {})
channel
  .join()
  .receive('ok', resp => {
    console.log('Joined successfully', resp)
    updateUi(resp)
  })
  .receive('error', resp => {
    console.log('Unable to join', resp)
  })

channel.on('state_change', resp => {
  updateUi(resp)
})

channel.onClose(() => {
  resetUi()
})
