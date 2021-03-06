module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main =
    Html.program
        { init = init "cats"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { topic : String
    , gifUrl : String
    , error : String
    }


init : String -> ( Model, Cmd Msg )
init topic =
    ( Model topic "waiting.gif" ""
    , getRandomGif topic
    )



-- UPDATE


type Msg
    = MorePlease
    | NewTopic String
    | NewGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        NewGif (Ok newUrl) ->
            ( Model model.topic newUrl "", Cmd.none )

        NewGif (Err err) ->
            ( { model | error = errorToString (err) }, Cmd.none )

        NewTopic s ->
            ( { model | topic = s }, Cmd.none )


errorToString : Http.Error -> String
errorToString err =
    case err of
        Http.BadUrl s ->
            "BadUrl " ++ s

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus _ ->
            "Bad Status"

        Http.BadPayload _ _ ->
            "Bad Payload"



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , input [ placeholder model.topic, onInput NewTopic ] []
        , select [ onInput NewTopic ]
            [ option [ value "cats" ] [ text "Cats" ]
            , option [ value "dogs" ] [ text "Dogs" ]
            , option [ value "fish" ] [ text "Fish" ]
            ]
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , br [] []
        , img [ src model.gifUrl ] []
        , p [] [ text model.error ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Http.send NewGif (Http.get url decodeGifUrl)


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string
