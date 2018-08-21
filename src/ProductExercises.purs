module ProductExercises where

import Product (both, Event)

import Data.Lens (lens, set, view, over, _1, _2, Lens, Lens')
import Data.Lens.At
import Data.Maybe
import Data.Profunctor.Strong
import Data.Tuple (Tuple(..), fst, snd)
import Data.Tuple.Nested (T2, T3, T4, get1, get2, get3, over3, tuple4)
import Prelude

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

-- exercises 1.4

-- 1.4.1
_object =
  lens getter setter where
    getter = _.object
    setter whole new = whole { object = new }

-- or shorter:
-- _object = lens _.object (_ { object = _ })

-- 1.4.2
stringified = over _2 show both

_bothObject = _2 <<< _object

-- exercise3 :: Tuple String String
-- 1.4.3
exercise3 = over _2 (view _object) both
-- or simply
-- exercise3 = over _2 _.object both

-- exercises 1.6
-- 1.6.part1

-- Hint: Start with set1 and define set2 in terms of it.
-- Hint: You want to use the Tn types instead of the Tuplen types.

fourLong = tuple4 1 2 3 4

set1 :: forall a b z. T2 a z -> b -> T2 b z 
set1 t v = set _1 v t

set2 :: forall a b z c. T3 a b z -> c -> T3 a c z
set2 (Tuple a t) v = Tuple a (set1 t v)

set3 :: forall a b c z d. T4 a b c z -> d -> T4 a b d z
set3 (Tuple a (Tuple b t)) v = Tuple a (Tuple b (set1 t v))

-- set2 fourLong "TWOTWOTWO" -- works

-- Create lenses _elt1, _elt2, and _elt3 that combine the appropriate getters and setters. 

_elt1 :: forall focus rest new.
         Lens (T2 focus rest) (T2 new rest) focus new
_elt1 =
  lens getter setter where
    getter = get1
    setter = set1

_elt2 :: forall p1 focus rest new.
         Lens (T3 p1 focus rest) (T3 p1 new rest) focus new
_elt2 =
  lens getter setter where
    getter = get2
    setter = set2

_elt3 :: forall p1 p2 focus rest new.
         Lens (T4 p1 p2 focus rest) (T4 p1 p2 new rest) focus new
_elt3 =
  lens getter setter where
    getter = get3
    setter = set3

-- over _elt3 ((*)60000) fourLong -- works

-- 1.8 law exercise
invalidSetGet :: forall a b ignored.
                 Lens { foo :: a, bar :: a | ignored }
                      { foo :: b, bar :: a | ignored }
                 a b

-- returns field bar but sets field foo
invalidSetGet = lens getter setter where
  getter = _.bar
  setter whole new = whole { foo = new }

testInvalidSetGet = let
  input = 10
  put = set invalidSetGet 10 {foo : 2, bar : 3}
  get = view invalidSetGet put
  in input /= get

invalidGetSet = invalidSetGet

testInvalidGetSet = let
  r = {foo : 2, bar : 3}
  got = view invalidSetGet r 
  put = set invalidSetGet got r
  in r /= put

invalidSetSet = lens getter setter where
  getter = _.foo
  setter whole new = whole { counter = whole.counter + 1
                           , foo = new + whole.counter }

testInvalidSetSet = let
  r = { foo : 0, counter : 0}
  r1 = set invalidSetSet 0 r
  r2 = set invalidSetSet 0 r1
  r3 = set invalidSetSet 0 r2
  in r /= r1 && r1 /= r2 && r2 /= r3

type AtType =
  forall t13 t14 t19 t5 t8.
  Strong t8 => At t14 Int t19 =>
  t8 (Maybe t19) (Maybe t19) ->
  t8 (Tuple (Tuple t13 t14) t5) (Tuple (Tuple t13 t14) t5)

type AtTypeSimplified =
  forall _1_ _2_ atAble something.
  At atAble Int something =>
  Lens' (Tuple (Tuple _1_  atAble) _2_) (Maybe something)

l1 :: AtType
l1 = _1 <<< _2 <<< at 3

-- verify the types are equivalent
l2 :: AtTypeSimplified
l2 = l1
