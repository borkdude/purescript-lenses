module TraversalStart where

import Prelude
import Data.Tuple (Tuple)
import Data.Tuple.Nested
import Data.Maybe (Maybe)
import Data.Lens (Traversal', Traversal, _1, traversed)
import Data.Traversable (class Traversable)
import Data.Lens.At (class At, at)
import Data.Map (Map)
import Data.Lens.Internal.Wander
import Data.Profunctor.Strong

-- rewrite without using map, use over
-- view traversed $ map Additive [1, 2, 3]
-- view traversed $ over traversed Additive [1, 2, 3]

-- Exercise: Use view to convert [["1"], ["2", "3"]] to "123". Then use view to convert [[1], [2, 3]] to Additive 10.

-- _trav_trav = traversed <<< traversed
-- view _trav_trav [["1"], ["2", "3"]]
-- view _trav_trav (over _trav_trav Additive [[1], [2,3]])

-- _trav_1 = traversed <<< _1
-- example = [ Tuple 1 2, Tuple 3 4 ]
-- Exercise: Predict the result of preview _trav_1 example. The answer is in src/Traversal.purs.
-- probably Just 1? Yep

-- Composition exercises

-- Add type annotations

-- t7 = trav1
-- t11 = trav2
-- t8 = wander
-- t10 = a
-- t9 = b

-- All optics are profunctor functions of this form: profunctor a b ->
-- profunctor s t

-- Wander is the clue that we’re looking at a Traversal, just as Strong is the
-- clue we’re looking at a Lens.

-- _trav_trav :: forall a trav2 trav1 profunctor b.
--               Traversable trav1 => Wander profunctor => Traversable trav2 =>
--               profunctor a b -> profunctor (trav1 (trav2 a)) (trav1 (trav2 b))
--               -- dus we gaan van een Wander a b naar een Wander van een geneste
--               -- traversable a naar een geneste traversable b
-- simplified:
_trav_trav :: forall a b trav1 trav2.
              Traversable trav1 => Traversable trav2 =>
              Traversal (trav1 (trav2 a)) (trav1 (trav2 b)) a b
_trav_trav = traversed <<< traversed

_1_trav ::
  forall a b traversable _2_.
  Traversable traversable =>
  Traversal (Tuple (traversable a) _2_) (Tuple (traversable b) _2_) a b
_1_trav = _1 <<< traversed


-- forall t11 t5 t7 t8. Traversable t7 => Wander t8 => At t5 Int t11 => t8 (Maybe t11) (Maybe t11) -> t8 (t7 t5) (t7 t5)

_trav_at3 :: forall a b trav1 m.
             Traversable trav1 => At m Int a =>
             Traversal (trav1 (m Int (Maybe a))) (trav1 (m Int (Maybe b))) (Maybe a) (Maybe b)
_trav_at3 = traversed <<< at 3
-- TODO: fix this shit

{-



-- Convert the following so that it makes no explicit reference to `Map`

_at3_trav_1' :: forall a _1_ . 
               Traversal' (Map Int (Tuple a _1_)) a
_at3_trav_1' = at 3 <<< traversed <<< _1

-}


