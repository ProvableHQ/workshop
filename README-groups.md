# Group Operations

## Overview

This example shows how to do basic operations over groups.

The set of affine points on the elliptic curve passed into the Leo compiler forms a group.
A subset of those points, defined by a chosen generator point, forms a subgroup of the group.

Leo supports the set of points in this subgroup as a primitive data type.
Group elements are special since their values can be defined as coordinate pairs ```(x, y)group```.

The `group` type keyword group must be used when specifying a pair of group coordinates since implicit syntax would collide with normal tuple `(a, b)` values.

```
let a = 0group; // the zero of the group

let b = group::GEN; // the group generator

let c = (0, 1)group; // coordinate notation
```

## Run Guide

To run this program, run:
```bash
leo run main <inputs>
```

Be sure to use `leo run` with the correct function and inputs as detailed in the `.leo` program. An example has been provided in the terminal for you. Using `leo run` will also compile the `.leo` file to aleo instructions (`.aleo`).
