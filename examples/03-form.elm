module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Char
import String
import List


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : String
    }


model : Model
model =
    Model "" "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Age age ->
            { model | age = age }

        Submit ->




-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , input [ type_ "text", placeholder "Age", onInput Age ] []
        , viewValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        age_okay : Bool
        age_okay =
            case String.toFloat model.age of
                Err msg ->
                    False

                Ok _ ->
                    True

        ( color, message ) =
            if String.length model.password <= 8 then
                ( "red", "Password needs to be longer than 8 characters." )
            else if not (String.any Char.isUpper model.password) then
                ( "red", "Password needs to include an upper-case character." )
            else if model.password /= model.passwordAgain then
                ( "red", "Passwords do not match!" )
            else if not age_okay then
                ( "red", "Age must be a number." )
            else
                ( "green", "OK" )
    in
        div [ style [ ( "color", color ) ] ] [ text message ]


isGoodPassword : String -> Bool
isGoodPassword password =
    String.length password
        > 8
        && (String.any Char.isUpper password)



-- isGoodPassword password =
