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
      if input /= ""  then (Model "" messages, Ports.msgToElectron input) else (Model input messages, Cmd.none)

    NewMessage str ->
      (Model input (str :: messages), Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Ports.msgFromElectron NewMessage

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "mdl-layout mdl-js-layout" ]
    [
    div [ class "mdl-textfield mdl-js-textfield mdl-textfield--floating-label" ]
      [
      input [ class "mdl-textfield__input", onInput Input ] []
      , label [ class "mdl-textfield__label" ] [ text "Shout" ]
      ]
    , span []
      [
      button [ class "mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent", onClick Send ] [ text "Send" ]
      ]
    , ul [ class "mdl-list" ] (List.map viewMessage (List.reverse model.messages))
    ]

viewMessage : String -> Html msg
viewMessage msg =
  li [ class "mdl-list__item" ]
    [
    span [ class "mdl-list__item-primary-content" ] [ text msg ]
    ]
