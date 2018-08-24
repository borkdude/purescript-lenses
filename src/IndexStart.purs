module IndexStart where

import Prelude

import Data.Maybe
import Data.Lens
import Data.Lens.At
import Data.Lens.Index
import Data.Traversable
import Data.Tuple

_1_ix1 :: forall indexed a z.
          Index indexed Int a =>
          Traversal' (Tuple indexed z) a
_1_ix1 = _1 <<< ix 1

_ix1_1 :: forall indexed a z.
          Index indexed Int (Tuple a z) =>
          Traversal' indexed a
_ix1_1 = ix 1 <<< _1

_ix1_at1 :: forall indexed keyed a.
            Index indexed Int keyed =>
            At keyed Int a =>
            Traversal' indexed (Maybe a)
_ix1_at1 = ix 1 <<< at 1

_ix1_ix1 :: forall ix1 ix2 a.
            Index ix1 Int ix2 =>
            Index ix2 Int a =>
            Traversal' ix1 a
_ix1_ix1 = ix 1 <<< ix 1
