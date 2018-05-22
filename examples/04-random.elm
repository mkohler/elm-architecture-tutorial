module Main exposing (..)

import Dict
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random
import Svg
import Svg.Attributes


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieFace1 : Int
    , dieFace2 : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 1 1, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFaces ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFaces (Random.pair (Random.int 1 6) (Random.int 1 6)) )

        NewFaces ( x1, x2 ) ->
            ( Model x1 x2, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ drawDie model.dieFace1
        , drawDie model.dieFace2
        , button [ onClick Roll ] [ text "Roll" ]
        ]


drawDie val =
    Svg.svg
        svgDieAttributes
        ([ svgDieRect
         ]
            ++ svgDie val
        )


svgDieAttributes =
    [ Svg.Attributes.width "500"
    , Svg.Attributes.height "500"
    , Svg.Attributes.viewBox "0 0 120 120"
    ]


svgDieRect =
    Svg.rect
        [ Svg.Attributes.x "10"
        , Svg.Attributes.y "10"
        , Svg.Attributes.width "100"
        , Svg.Attributes.height "100"
        , Svg.Attributes.rx "15"
        , Svg.Attributes.ry "15"
        , Svg.Attributes.stroke "#000000"
        , Svg.Attributes.strokeWidth "3"
        , Svg.Attributes.fill "none"
        ]
        []


svgDotCenter =
    Svg.circle
        [ Svg.Attributes.cx "60"
        , Svg.Attributes.cy "60"
        , Svg.Attributes.r "10"
        ]
        []


svgDotUpperLeft =
    Svg.circle
        [ Svg.Attributes.cx "30"
        , Svg.Attributes.cy "30"
        , Svg.Attributes.r "10"
        ]
        []


svgDotUpperRight =
    Svg.circle
        [ Svg.Attributes.cx "90"
        , Svg.Attributes.cy "30"
        , Svg.Attributes.r "10"
        ]
        []


svgDotLowerRight =
    Svg.circle
        [ Svg.Attributes.cx "90"
        , Svg.Attributes.cy "90"
        , Svg.Attributes.r "10"
        ]
        []


svgDotLowerLeft =
    Svg.circle
        [ Svg.Attributes.cx "30"
        , Svg.Attributes.cy "90"
        , Svg.Attributes.r "10"
        ]
        []


svgDotCenterLeft =
    Svg.circle
        [ Svg.Attributes.cx "30"
        , Svg.Attributes.cy "60"
        , Svg.Attributes.r "10"
        ]
        []


svgDotCenterRight =
    Svg.circle
        [ Svg.Attributes.cx "90"
        , Svg.Attributes.cy "60"
        , Svg.Attributes.r "10"
        ]
        []


svgDie value =
    case value of
        1 ->
            svgDieOne

        2 ->
            svgDieTwo

        3 ->
            svgDieThree

        4 ->
            svgDieFour

        5 ->
            svgDieFive

        6 ->
            svgDieSix

        _ ->
            svgDieTwo


svgDieOne =
    [ svgDotCenter ]


svgDieTwo =
    [ svgDotUpperLeft, svgDotLowerRight ]


svgDieThree =
    [ svgDotUpperLeft, svgDotCenter, svgDotLowerRight ]


svgDieFour =
    [ svgDotUpperLeft, svgDotUpperRight, svgDotLowerLeft, svgDotLowerRight ]


svgDieFive =
    svgDieFour ++ svgDieOne


svgDieSix =
    svgDieFour ++ [ svgDotCenterLeft, svgDotCenterRight ]
