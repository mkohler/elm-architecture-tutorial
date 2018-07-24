module Main exposing (..)

import Html
import Html exposing (Html, button, div)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { time : Time
    , paused : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { time = 0, paused = False }, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | TogglePause


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        TogglePause ->
            ( { model | paused = not model.paused }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.paused then
        Sub.none
    else
        Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        circle_color =
            "#0B79CE"

        line_color =
            if model.time == 0 then
                circle_color
            else
                "#023963"

        secondAngle =
            turns (Time.inMinutes model.time)

        secondHandX =
            toString (50 + 40 * cos secondAngle)

        secondHandY =
            toString (50 + 40 * sin secondAngle)

        button_title =
            if model.paused then
                "Play"
            else
                "Pause"
    in
        div []
            [ svg [ viewBox "0 0 100 100", width "300px" ]
                [ circle [ cx "50", cy "50", r "45", fill circle_color ] []
                , line [ x1 "50", y1 "50", x2 secondHandX, y2 secondHandY, stroke line_color ] []
                ]
            , button [ onClick TogglePause ] [ Html.text button_title ]
            ]
