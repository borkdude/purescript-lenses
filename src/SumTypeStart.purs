module SumTypeStart where

import Prelude
import Data.Lens (Prism, Prism', prism', prism, review, preview, Traversal, _Right, traversed)
import Data.Traversable (class Traversable)

import Data.Maybe
import Data.Either
import Data.Int (fromString)

import Color (Color)
import Color as Color

import SumType

{-   If you want to try out examples, paste the following into the repl.

import SumTypeSolutions
import Data.Lens
import Data.Lens.Prism
import Data.Maybe
import Data.Either
-}

{-

Exercise
I want a prism that selects the central Point from a RadialGradient, ignoring the two colors. Given a radial Fill like this one:

-}

type RadialInterchange =
  { color1 :: Color
  , color2 :: Color
  , center :: Point
  }

-- prism' uses Maybe
-- The prism' function (note the ') expects a focuser that returns a Maybe.

-- Since prism and prism' are so similar, just use whichever is more convenient at the moment.

_centerPoint' :: Prism' Fill RadialInterchange
_centerPoint' = prism constructor focuser where
  -- constructor :: RadialInterchange -> Fill
  constructor {color1, color2, center} = RadialGradient color1 color2 center
  focuser = case _ of
    RadialGradient color1 color2 center ->
      Right {color1, color2, center}
    otherCases -> Left otherCases

x = preview _centerPoint fillRadial -- (Just (1.0, 3.4))

-- p59
-- As an exercise, try to write the correct type.

-- > :t _Right <<< traversed
-- forall t10 t11 t12 t6 t9.
-- Choice t9 => Traversable t12 => Wander t9 =>
-- ^^^^^^ ^^^^^^
-- t9 t11 t10 -> t9 (Either t6 (t12 t11)) (Either t6 (t12 t10))

myOptic :: forall trav _1_ a b.
           Traversable trav =>
           Traversal (Either _1_ (trav a))
                     (Either _1_ (trav b)) a b

myOptic = _Right <<< traversed

-- It turns out that Wander is shorthand for a profunctor that’s both Strong and Choice:
-- class (Strong p, Choice p) <= Wander p where ...

-- 6.7 Prisms aren’t just for sum types (exercises)

_intSource :: Prism' String String
_intSource = prism' constructor focuser where
  constructor s = s
  focuser s = map show $ fromString s

-- review ~ part -> whole
-- preview ~ whole -> part

-- Make sure _intSource obeys the prism laws.
-- review-preview: preview retrieves what was given to review.

testReviewPreview = ("123" # review _intSource # preview _intSource) == (Just "123")
                    
-- preview-review:
-- If preview retrieves something, review can create the original from that something.
testPreviewReview = ("123" # preview _intSource <#> review _intSource) == (Just "123")

_int :: Prism' String Int
_int = prism' constructor focuser where
  constructor i = show i 
  focuser = fromString

testReviewPreviewInt = (123 # review _int # preview _int) == (Just 123)
testPreviewReviewInt = ("123" # preview _int <#> review _int) == (Just "123")

-- Yes.
