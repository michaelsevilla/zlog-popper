This experiment performs a parameter sweep over the possible combinations of
low-level storage interface (kv, bytestream) and client mappings (1:1, N:1),
and in the case of the bytestream interface, it also tests a write(offset) and
append strategy.

The motivation for this experiment is to winnow down the possible design
space. We make the observation that any physical design must be based on one
of the configurations tested by this experiment, and all other features that
must be added would be pure overhead. Thus, this experiment produces a
best-case performance baseline.
