module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode
import Bootstrap.Navbar as Navbar
import Bootstrap.Accordion as Accordion
import Bootstrap.Card as Card
import Bootstrap.Button as Button


main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { navbarState : Navbar.State
    , accordionState : Accordion.State
    }


init : ( Model, Cmd Msg )
init =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg
    in
        ( { navbarState = navbarState
          , accordionState = Accordion.initialState
          }
        , navbarCmd
        )


type Msg
    = SendCommand String
    | PostResult (Result Http.Error String)
    | NavbarMsg Navbar.State
    | AccordionMsg Accordion.State


sendCommand : String -> Cmd Msg
sendCommand cmd =
    let
        url =
            "api/v1/" ++ cmd

        request =
            Http.post url Http.emptyBody (Json.Decode.succeed "")
    in
        Http.send PostResult request


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendCommand command ->
            ( model, sendCommand command )

        PostResult _ ->
            ( model, Cmd.none )

        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )

        AccordionMsg state ->
            ( { model | accordionState = state }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Accordion.subscriptions model.accordionState AccordionMsg



-- View


menu : Model -> Html Msg
menu model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.info
        |> Navbar.brand [ href "#" ] [ text "🏠" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#rooms" ] [ text "Rooms" ]
            , Navbar.itemLink [ href "#people" ] [ text "People" ]
            ]
        |> Navbar.view model.navbarState


livingRoomPage : Model -> Html Msg
livingRoomPage model =
    div []
        [ Button.button
            [ Button.primary
            , Button.onClick (SendCommand "scenes/LightScene_10/activate")
            ]
            [ text "All Lamps On" ]
        , Button.button
            [ Button.primary
            , Button.onClick (SendCommand "scenes/LightScene_11/activate")
            ]
            [ text "All Lamps Off" ]
        , Button.button
            [ Button.primary
            , Button.onClick (SendCommand "scenes/LightScene_12/activate")
            ]
            [ text "Main Lamp On" ]
        ]


roomsAccordion : Model -> Html Msg
roomsAccordion model =
    Accordion.config AccordionMsg
        |> Accordion.withAnimation
        |> Accordion.cards
            [ Accordion.card
                { id = "livingRoomCard"
                , options = []
                , header =
                    Accordion.header [] <| Accordion.toggle [] [ text "Living Room" ]
                , blocks =
                    [ Accordion.block []
                        [ Card.text [] [ livingRoomPage model ] ]
                    ]
                }
            , Accordion.card
                { id = "bedRoomCard"
                , options = []
                , header =
                    Accordion.header [] <|
                        Accordion.toggle []
                            [ text "Bedroom"
                            ]
                , blocks =
                    [ Accordion.block []
                        [ Card.text [] [ text "Add bedroom stuff" ] ]
                    ]
                }
            ]
        |> Accordion.view model.accordionState


view : Model -> Html Msg
view model =
    div []
        [ menu model
        , div
            [ classList
                [ ( "container-fluid", True )
                , ( "container-accordion", True )
                ]
            ]
            [ roomsAccordion model ]
        ]
