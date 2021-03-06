'use strict'
import {app as App, BrowserWindow, ipcMain as IpcMain} from 'electron'

let mainWindow = null

App.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    App.quit()
  }
})

App.on('ready', () => {
  mainWindow = new BrowserWindow({width: 800, height: 600})
  mainWindow.loadURL('file://' + __dirname + '/../frontend/index.html')
  // mainWindow.webContents.openDevTools()

  mainWindow.on('closed', () => {
    mainWindow = null
  })
  IpcMain.on('input', (event, msg) => {
    event.sender.send('input', msg.toUpperCase())
  })
  IpcMain.on('error', (event, msg) => {
    console.error(msg)
  })
  IpcMain.on('quit', (event, msg) => {
    App.quit()
  })
})
