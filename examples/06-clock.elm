module MyClock exposing (..)

import Html
import Html exposing (Html, button, div)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes as SvgA
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


calcHand : ( Float, Float ) -> Float -> Float -> ( Float, Float )
calcHand ( centerX, centerY ) length angleRadians =
    ( centerX + length * cos angleRadians
    , centerY + length * sin angleRadians
    )


drawLine : ( Float, Float ) -> ( Float, Float ) -> List (Attribute msg) -> Svg msg
drawLine ( x1, y1 ) ( x2, y2 ) attrs =
    line
        ([ SvgA.x1 (toString x1)
         , SvgA.y1 (toString y1)
         , SvgA.x2 (toString x2)
         , SvgA.y2 (toString y2)
         ]
            ++ attrs
        )
        []


drawClock model =
    let
        circle_color =
            "#0B79CE"

        outerRingColor =
            "#808080"

        hand_color =
            "#023963"

        center =
            ( 50, 50 )

        handStyles =
            [ SvgA.stroke hand_color, SvgA.strokeWidth "3" ]

        length =
            44

        ring =
            circle [ cx "50", cy "50", r "50", fill outerRingColor ] []

        face =
            circle [ cx "50", cy "50", r "45", fill circle_color ] []

        hub =
            circle [ cx "50", cy "50", r "3", fill hand_color ] []

        secondAngle =
            turns (Time.inMinutes model.time)

        secondHand =
            drawLine
                center
                (calcHand center length secondAngle)
                [ SvgA.stroke "#000000" ]

        minuteHand =
            drawLine
                center
                (calcHand center (length * 0.9) (Time.inHours model.time))
                handStyles

        hourAngle =
            (Time.inHours model.time) / 60

        hourHand =
            drawLine center (calcHand center (length * 0.7) hourAngle) handStyles
    in
        [ ring
        , face
        , secondHand
        , minuteHand
        , hourHand
        , hub
        ]


view : Model -> Html Msg
view model =
    if model.time == 0 then
        div [] []
    else
        let
            button_title =
                if model.paused then
                    "Play"
                else
                    "Pause"
        in
            div []
                [ svg [ viewBox "0 0 100 100", width "300px" ]
                    (drawClock model)
                , button [ onClick TogglePause ] [ Html.text button_title ]
                ]
