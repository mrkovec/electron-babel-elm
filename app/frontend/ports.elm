port module Ports exposing (..)

port msgToElectron : String -> Cmd msg
port msgFromElectron : (String -> msg) -> Sub msg
