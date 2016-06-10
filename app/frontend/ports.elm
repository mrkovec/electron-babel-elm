port module Ports exposing (..)
import Json.Encode as Json

type alias IpcMsg =
  { msg : String
  , body : Maybe Json.Value
  }

port msgToElectron : IpcMsg -> Cmd msg
port msgFromElectron : (IpcMsg -> msg) -> Sub msg
