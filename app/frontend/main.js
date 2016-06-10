'use strict'
import Elm from './elm.js'
import {ipcRenderer as IpcRenderer} from 'electron'
// until import from material-design-lite starts working
require('material-design-lite')

window.onload = () => {
  let appcontainer = document.getElementById('app')
  let app = Elm.MyApp.embed(appcontainer)

  // ports <=> ipcRenderer
  app.ports.msgToElectron.subscribe((msg) => {
    IpcRenderer.send(msg.msg, msg.body)
  })
  IpcRenderer.on('input', (event, msg) => {
    app.ports.msgFromElectron.send({msg: 'input', body: msg})
  })

  // after every DOM change manually registering new elements for mdl
  let observer = new MutationObserver(() => {
      componentHandler.upgradeElements(appcontainer.querySelectorAll('[class*="mdl-"]'))
  })
  observer.observe(appcontainer, { attributes: true, childList: true, characterData: true })
}
