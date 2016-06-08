module MyApp exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Ports

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { input : String
  , messages : List String
  }

init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)

-- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String

update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send ->
      (Model "" messages, Ports.msgToElectron input)

    NewMessage str ->
      (Model input (str :: messages), Cmd.none)



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Ports.msgFromElectron NewMessage


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [onInput Input] []
    , button [onClick Send] [text "Send"]
    , div [] (List.map viewMessage (List.reverse model.messages))
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
