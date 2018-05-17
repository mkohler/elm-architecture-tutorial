module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
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
    , lefthanded : Bool
    , error : String
    }


model : Model
model =
    Model "" "" "" "" False ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Lefthanded
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
            { model | error = validate model }

        Lefthanded ->
            { model | lefthanded = not model.lefthanded }



-- VIEW


fieldStyle =
    style [ ( "display", "block" ), ( "margin", "10px" ) ]


view : Model -> Html Msg
view model =
    div []
        [ makeField [ type_ "text", placeholder "Name", onInput Name ] []
        , makeField [ type_ "password", placeholder "Password", onInput Password ] []
        , makeField [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , makeField [ type_ "text", placeholder "Age", onInput Age ] []
        , makeField [ type_ "checkbox", onClick Lefthanded ] []
        , button [ onClick Submit, fieldStyle ] [ text "Submit" ]
        , div [ fieldStyle ] [ text (model.error) ]
        ]


makeField : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
makeField attrs elems =
    let
        attrs_with_style =
            attrs ++ [ fieldStyle ]
    in
        input attrs_with_style elems


validate : Model -> String
validate model =
    let
        age_okay : Bool
        age_okay =
            case String.toFloat model.age of
                Err msg ->
                    False

                Ok _ ->
                    True

        message =
            if String.length model.password <= 8 then
                "Password needs to be longer than 8 characters."
            else if not (String.any Char.isUpper model.password) then
                "Password needs to include an upper-case character."
            else if model.password /= model.passwordAgain then
                "Passwords do not match!"
            else if not age_okay then
                "Age must be a number."
            else if not model.lefthanded then
                "Checkbox must be checked."
            else
                "OK"
    in
        message
