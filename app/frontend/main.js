'use strict'
import Elm from './elm.js'
import {ipcRenderer as IpcRenderer} from 'electron'

window.onload = () => {
  let app = Elm.MyApp.embed(document.getElementById('app'))
  app.ports.msgToElectron.subscribe((msg) => {
    IpcRenderer.send('msg', msg)
  })
  IpcRenderer.on('msg', (event, msg) => {
    app.ports.msgFromElectron.send(msg)
  })
}
