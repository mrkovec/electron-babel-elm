module MyApp exposing (..)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import Html.Lazy exposing (lazy)
import Json.Encode as Json
import Json.Decode exposing (string)
import Ports


main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


type alias Model =
  { input : Maybe String
  , messages : List String
  }


init : (Model, Cmd Msg)
init =
  Model Nothing [] ! []


-- UPDATE


type Msg
  = Input String
  | Send
  | NewMessage Ports.IpcMsg
  | Error String
  | QuitApp


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput ->
      { model
        | input = Just newInput
        , messages = model.messages
      }
        ! []

    Send ->
      case model.input of
        Just str ->
          { model
            | input = Nothing
            , messages = model.messages
          }
            ! [ Ports.msgToElectron (Ports.IpcMsg "input" <| Just <| Json.string str) ]
        Nothing ->
          model ! []

    NewMessage ipcmsg ->
        case ipcmsg.body of
          Just body ->
            case Json.Decode.decodeValue (Json.Decode.string) body of
              Ok str ->
                { model | messages = (str :: model.messages) } ! []
              Err msg ->
                model ! []
          Nothing ->
            model ! []

    QuitApp ->
      model ! [ Ports.msgToElectron (Ports.IpcMsg "quit" Nothing) ]

    Error err ->
      model ! [ Ports.msgToElectron (Ports.IpcMsg "error" <| Just <| Json.string err) ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Ports.msgFromElectron filterMsg


filterMsg : Ports.IpcMsg -> Msg
filterMsg ipcmsg =
  if ipcmsg.msg == "input" then
      NewMessage ipcmsg
  else
      Error ("unknown message from Electron: " ++ ipcmsg.msg)


-- VIEW


view : Model -> Html Msg
view model =
  mdlLayout [ class "mdl-layout--fixed-header", style [ ("backgroundColor", "#D8D8D8") ] ]
    [ mdlHeader [onClick QuitApp]
    , mdlInput [onInput Input] [ text "Shout" ]
    , div []
        [ mdlButton [ onClick Send ] [ text "Send" ]
        ]
    , lazy mdlList model.messages
    , mdlFooter [text "electron-babel-elm"]
    ]


mdlLayout :  List (Attribute Msg) -> List (Html Msg) -> Html Msg
mdlLayout attrs inns =
  div (List.append [class "mdl-layout mdl-js-layout"] attrs) inns


mdlHeader : List (Attribute Msg) -> Html Msg
mdlHeader attrs =
  header [ class "mdl-layout__header", style [ ("position", "relative") ] ]
  [ button [id "mb", class "mdl-button mdl-js-button mdl-button--icon"]
    [ i [ class "material-icons" ] [ text "more_vert" ]
    ]
  , ul [class "mdl-menu mdl-menu--bottom-left mdl-js-menu mdl-js-ripple-effect", attribute "for" "mb" ]
    [ li (List.append [class "mdl-menu__item" ] attrs) [ text "Quit"] ]
  ]


mdlInput : List (Attribute Msg) -> List (Html Msg) -> Html Msg
mdlInput attrs inns =
  div (List.append [ class "mdl-textfield mdl-js-textfield mdl-textfield--floating-label" ] attrs)
    [ input (List.append [ class "mdl-textfield__input" ] attrs) []
    , label [ class "mdl-textfield__label" ] inns
    ]


mdlButton : List (Attribute Msg) -> List (Html Msg) -> Html Msg
mdlButton attrs inns =
  button (List.append [ class "mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent" ] attrs) inns


mdlList : List String  -> Html msg
mdlList msgs =
  ul [ class "mdl-list" ] (List.map (viewMessage) (List.reverse msgs))


viewMessage : String -> Html msg
viewMessage msg =
  li [ class "mdl-list__item" ]
    [ span [ class "mdl-list__item-primary-content" ] [ text msg ]
    ]


mdlFooter : List (Html Msg) -> Html Msg
mdlFooter inns =
  footer [ class "mdl-mini-footer" ]
    [ div [class "mdl-mini-footer__left-section"] [ div [class "mdl-logo"] inns ] ]
