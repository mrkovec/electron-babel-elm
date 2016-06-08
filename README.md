# [Electron](http://http://electron.atom.io/)  + [Babel](https://babeljs.io/)  + [Elm](http://elm-lang.org/)  app boilerplate.

Simple app based on Elm websockets example, but with Electron as "backend".

```bash
npm install -g elm
git clone https://github.com/mrkovec/electron-babel-elm
cd electron-babel-elm
npm install
elm make app/frontend/main.elm --output app/frontend/elm.js --yes
npm start
```

