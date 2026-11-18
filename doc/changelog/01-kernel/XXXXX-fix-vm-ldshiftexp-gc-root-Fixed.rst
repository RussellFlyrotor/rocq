- **Fixed:**
  The VM could crash in the garbage collector when evaluating :g:`ldshiftexp`,
  since it left an untagged integer in a GC root while allocating the result
  (`#XXXXX <https://github.com/rocq-prover/rocq/pull/XXXXX>`_,
  fixes `#ISSUE <https://github.com/rocq-prover/rocq/issues/ISSUE>`_,
  by Russell Hart).
