# Tests for `move.namespace`

## Happy path

Create a namespace and add some history to it

```unison
a.termInA = 1
unique type a.T = T
```

```ucm

  I found and typechecked these definitions in scratch.u. If you
  do an `add` or `update`, here's how your codebase would
  change:
  
    ⍟ These new definitions are ok to `add`:
    
      unique type a.T
      a.termInA : Nat

```
```ucm
  ☝️  The namespace .happy is empty.

.happy> add

  ⍟ I've added these definitions:
  
    unique type a.T
    a.termInA : Nat

```
```unison
a.termInA = 2
unique type a.T = T1 | T2
```

```ucm

  I found and typechecked these definitions in scratch.u. If you
  do an `add` or `update`, here's how your codebase would
  change:
  
    ⍟ These names already exist. You can `update` them to your
      new definition:
    
      unique type a.T
      a.termInA : Nat

```
```ucm
.happy> update

  ⍟ I've updated these names to your new definition:
  
    unique type a.T
    a.termInA : Nat

```
Should be able to move the namespace, including its types, terms, and sub-namespaces.

```ucm
.happy> move.namespace a b

  Done.

.happy> ls b

  1. T       (type)
  2. T/      (2 definitions)
  3. termInA (Nat)

.happy> history b

  Note: The most recent namespace hash is immediately below this
        message.
  
  ⊙ 1. #imgt3sdjum
  
    + Adds / updates:
    
      T T.T1 T.T2 termInA
    
    - Deletes:
    
      T.T
  
  □ 2. #r71j4144fe (start of history)

```
## Namespace history


Create some namespaces and add some history to them

```unison
a.termInA = 1
b.termInB = 10
```

```ucm

  I found and typechecked these definitions in scratch.u. If you
  do an `add` or `update`, here's how your codebase would
  change:
  
    ⍟ These new definitions are ok to `add`:
    
      a.termInA : Nat
      b.termInB : Nat

```
```ucm
  ☝️  The namespace .history is empty.

.history> add

  ⍟ I've added these definitions:
  
    a.termInA : Nat
    b.termInB : Nat

```
```unison
a.termInA = 2
b.termInB = 11
```

```ucm

  I found and typechecked these definitions in scratch.u. If you
  do an `add` or `update`, here's how your codebase would
  change:
  
    ⍟ These names already exist. You can `update` them to your
      new definition:
    
      a.termInA : Nat
      b.termInB : Nat

```
```ucm
.history> update

  ⍟ I've updated these names to your new definition:
  
    a.termInA : Nat
    b.termInB : Nat

```
Now, if we soft-delete a namespace, but move another over it we expect the history to be replaced, and we expect the history from the source to be wiped out.

```ucm
.history> delete.namespace b

  Done.

.history> move.namespace a b

  Done.

-- Should be the history from 'a'
.history> history b

  Note: The most recent namespace hash is immediately below this
        message.
  
  ⊙ 1. #j0cjjqepb3
  
    + Adds / updates:
    
      termInA
  
  □ 2. #m8smmmgjso (start of history)

-- Should be empty
.history> history a

  ☝️  The namespace .history.a is empty.

```
## Moving over an existing branch 

Create some namespace and add some history to them

```unison
a.termInA = 1
b.termInB = 10
```

```ucm

  I found and typechecked these definitions in scratch.u. If you
  do an `add` or `update`, here's how your codebase would
  change:
  
    ⍟ These new definitions are ok to `add`:
    
      a.termInA : Nat
      b.termInB : Nat

```
```ucm
  ☝️  The namespace .existing is empty.

.existing> add

  ⍟ I've added these definitions:
  
    a.termInA : Nat
    b.termInB : Nat

```
```unison
a.termInA = 2
b.termInB = 11
```

```ucm

  I found and typechecked these definitions in scratch.u. If you
  do an `add` or `update`, here's how your codebase would
  change:
  
    ⍟ These names already exist. You can `update` them to your
      new definition:
    
      a.termInA : Nat
      b.termInB : Nat

```
```ucm
.existing> update

  ⍟ I've updated these names to your new definition:
  
    a.termInA : Nat
    b.termInB : Nat

.existing> move.namespace a b

  ⚠️
  
  A branch existed at the destination: b so I over-wrote it.
  
  Tip: You can use `undo` or `reflog` to undo this change.

```
## Moving the Root 

I should be able to move the root into a sub-namespace

```ucm
-- Should request confirmation
.> move.namespace . .root.at.path

  ⚠️
  
  Moves which affect the root branch cannot be undone, are you sure?
  Re-run the same command to proceed.

.> move.namespace . .root.at.path

  Done.

.> ls

  1. root/ (655 definitions)

.> history

  Note: The most recent namespace hash is immediately below this
        message.
  
  
  
  □ 1. #563hh6p6el (start of history)

```
```ucm
.> ls .root.at.path

  1. builtin/  (649 definitions)
  2. existing/ (1 definition)
  3. happy/    (4 definitions)
  4. history/  (1 definition)

.> history .root.at.path

  Note: The most recent namespace hash is immediately below this
        message.
  
  ⊙ 1. #hag5rpoufl
  
    - Deletes:
    
      existing.b.termInB
    
    > Moves:
    
      Original name      New name
      existing.a.termInA existing.b.termInA
  
  ⊙ 2. #istoalcv4i
  
    + Adds / updates:
    
      existing.a.termInA existing.b.termInB
    
    = Copies:
    
      Original name     New name(s)
      happy.b.termInA   existing.a.termInA
      history.b.termInA existing.a.termInA
  
  ⊙ 3. #aqfd0ke891
  
    + Adds / updates:
    
      existing.a.termInA existing.b.termInB
  
  ⊙ 4. #iu1fliq0vp
  
    > Moves:
    
      Original name     New name
      history.a.termInA history.b.termInA
  
  ⊙ 5. #b4uh32qomr
  
    - Deletes:
    
      history.b.termInB
  
  ⊙ 6. #r2qkrfnb78
  
    + Adds / updates:
    
      history.a.termInA history.b.termInB
    
    = Copies:
    
      Original name   New name(s)
      happy.b.termInA history.a.termInA
  
  ⊙ 7. #mbdojpack3
  
    + Adds / updates:
    
      history.a.termInA history.b.termInB
  
  ⊙ 8. #pe4f6sjfp6
  
    > Moves:
    
      Original name   New name
      happy.a.T       happy.b.T
      happy.a.T.T1    happy.b.T.T1
      happy.a.T.T2    happy.b.T.T2
      happy.a.termInA happy.b.termInA
  
  ⊙ 9. #h2juap75ba
  
    + Adds / updates:
    
      happy.a.T happy.a.T.T1 happy.a.T.T2 happy.a.termInA
    
    - Deletes:
    
      happy.a.T.T
  
  ⊙ 10. #mj02gp51u2
  
    + Adds / updates:
    
      happy.a.T happy.a.T.T happy.a.termInA
  
  There's more history before the versions shown here. Use
  `history #som3n4m3space` to view history starting from a given
  namespace hash.
  
  ⠇
  
  ⊙ 11. #41cbkjj0k8
  

```
I should be able to move a sub namespace _over_ the root.

```ucm
-- Should request confirmation
.> move.namespace .root.at.path.happy .

  ⚠️
  
  Moves which affect the root branch cannot be undone, are you sure?
  Re-run the same command to proceed.

.> move.namespace .root.at.path.happy .

  Done.

.> ls

  1. b/    (4 definitions)
  2. patch (patch)

.> history

  Note: The most recent namespace hash is immediately below this
        message.
  
  ⊙ 1. #ddf955gbso
  
    + Adds / updates:
    
      b.T b.T.T1 b.T.T2 b.termInA
  
  ⊙ 2. #8c8naats2k
  
    - Deletes:
    
      a.T a.T.T1 a.T.T2 a.termInA
  
  ⊙ 3. #qat4i8g3qm
  
    + Adds / updates:
    
      a.T a.T.T1 a.T.T2 a.termInA
    
    - Deletes:
    
      a.T.T
  
  □ 4. #kfuu64io6v (start of history)

```
```ucm
-- should be empty
.> ls .root.at.path.happy

  nothing to show

.> history .root.at.path.happy

  ☝️  The namespace .root.at.path.happy is empty.

```
