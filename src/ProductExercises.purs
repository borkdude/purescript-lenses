module ProductExercises where

import Product (both, Event)

import Prelude
import Data.Tuple (Tuple(..), fst, snd)
import Data.Tuple.Nested (T2, T3, T4, get1, get2, get3)
import Data.Lens (lens, set, view, over, _2, Lens, Lens')

{- Paste the following into the repl

import Product
import Data.Tuple.Nested 
import Data.Lens
import Data.Lens as Lens
 
-}

{-

-- These are imports you're likely to need.
-- They're commented out to keep `pulp build` from whining about them.   

import Product (both, Event)

import Prelude
import Data.Tuple (Tuple(..), fst, snd)
import Data.Tuple.Nested (T2, T3, T4, get1, get2, get3)
import Data.Lens (lens, set, view, over, _2, Lens, Lens')

-}

_action =
  lens getter setter where
    getter = _.action
    setter whole new = whole { action = new }

_object =
  lens getter setter where
    getter = _.object
    setter whole new = whole { object = new }

-- or shorter:
-- _object = lens _.object (_ { object = _ })

stringified = over _2 show both

_bothObject = _2 <<< _object

-- exercise3 :: Tuple String String
exercise3 = over _2 (view _object) both
