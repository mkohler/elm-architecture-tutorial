module Main exposing (..)

import Dict
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random


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
        [ button [ onClick Roll ] [ text "Roll" ]
        , img
            [ src (getDieFace model.dieFace1) ]
            []
        , img
            [ src (getDieFace model.dieFace2) ]
            []
        ]


getDieFace : Int -> String
getDieFace val =
    "Dice-" ++ toString (val) ++ ".svg"
