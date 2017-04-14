module Lens exposing (lens, (.), compose, Lens)

{-| Simple lens implementation.

# the lens type
@docs Lens

# a lens constructor
@docs lens

# function and infix form for composing lenses
@docs compose, (.)

# general usage

Let's say you have the following type:

type alias Participant =
    { id : Id
    , name : String
    }

then you can construct a lens for the name property as such:

nameLens : Lens { b | name : a } a
nameLens =
    lens .name (\a b -> { b | name = a })

Because elm has extensible records and the concrete record and property type are
both only defined as type variables, this lens can be applied to all concrete
record types that have an attribute with the name 'name'.
-}


{-| A lens with functions for getting, setting and flipped setting a property of a record.
-}
type alias Lens rec elem =
    { get : rec -> elem
    , set : elem -> rec -> rec
    , fset : rec -> elem -> rec
    }


{-| Creates a lens. It needs two functions, one for accessing and one for
    creating a new record with the new value.

Example:
nameLens : Lens { b | name : a } a
nameLens =
    lens .name (\a b -> { b | name = a })
-}
lens : (rec -> elem) -> (elem -> rec -> rec) -> Lens rec elem
lens get set =
    Lens get set (flip set)


{-| Compose two lenses to allow access to nested properties.
-}
compose : Lens a b -> Lens b c -> Lens a c
compose =
    (.)


{-| The infix version of compose.
-}
(.) : Lens a b -> Lens b c -> Lens a c
(.) lensAB lensBC =
    let
        set c a =
            lensAB.get a |> lensBC.set c |> (\b -> lensAB.set b a)

        get =
            lensAB.get >> lensBC.get
    in
        lens get set
