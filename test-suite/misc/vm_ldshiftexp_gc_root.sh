#!/usr/bin/env bash
# ldshiftexp in the VM must not leave an untagged integer in a GC root.
set -e

export PATH=$BIN:$PATH
export OCAMLRUNPARAM=s=1,o=1

d=$(mktemp -d)
trap 'rm -rf "$d"' EXIT

cat > "$d/vm_ldshiftexp_gc_root.v" <<'V'
From Corelib Require Import PrimFloat PrimInt63.

Fixpoint build (n : nat) (x : float) (acc : list float) : list float :=
  match n with
  | O => acc
  | S n =>
    let y := ldshiftexp (ldshiftexp x 2100%uint63) 2102%uint63 in
    build n y (cons y acc)
  end.

Fixpoint sum (l : list float) (s : float) : float :=
  match l with
  | nil => s
  | cons x l => sum l (PrimFloat.add s x)
  end.

Fixpoint loop (n : nat) (s : float) : float :=
  match n with
  | O => s
  | S n => loop n (ldshiftexp (sum (build 1000 s nil) 0%float) 2090%uint63)
  end.

Definition result := Eval vm_compute in loop 30 1%float.
V

${coqc#"$BIN"} "$d/vm_ldshiftexp_gc_root.v"
