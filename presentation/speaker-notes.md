# Cluster Editing Presentation Speaker Notes

## Introduction

1. Welcome, etc.
2. Outline ? No
3. Def Cluster Graph, w/ example
4. CE: Turn G into CG
   <-->
   just remove all edges?
5. no! that's not interesting.
   better: optimization version -> as few edits as possible
   <-->
   result of minimal cluster editing
   <-->
   Motivation: bioinformatics (gene sequencing, transcriptomics, and more), machine learning
   CUT (-> main focus: cleaning up corrupted (measurement errors) or duplicated data)
   For us: PACE Challenge
6. Quick formal definition

## Fixed-Parameter Algorithms

7. CE NP-Complete
   -> fixed-parameter approach
   <-->
   Def FPT. Quickly explain k, n, c
   -> "contain" exponential increase in runtime in dependency on parameter instead of input size
8. Problem Def with parameter
   Increasing parameter to find optimal solution
9. Central Concepts:
   - Bounded Search Tree Algorithms
   - Kernels & Data Reduction Rules

Note here: The theoretical underpinnings here developed in previous work by others, especially
Sebastian Böcker et al.

## Bounded Search Trees

10. also called "branching algorithm"
   *KEEP THIS SHORT; RELY MORE ON EXAMPLE*
   essentially backtracking; taking parameter into account
   Algo branches into multiple cases, taking a different decision regarding the solution in all and
   recursively calls itself
   This way a "search tree" is built up, with the decision points as nodes
   Def Bounded: Number of recursive calls per node limited (usually fixed), each decision reduces
   the parameter
   Stop if parameter 0, or solution is trivial, or non-existence of solution is trivial
   => if, whenever there is a solution, there is also some seq of decisions to find it, the
   algorithm solves the problem
11. Now: Simple BST algo for CE
   First, central concept: Conflict Triples
   Def CT, "i.e. they form an induced P_3"
   No CTs <=> cluster graph
   "resolving a CT"
12. Simple algo: describe
   (slide omits some details like stopping at k=0, etc.)
   Leads to O(3^k) size search tree
13. Weighted CE Def
   Infinities for "forbidden", "permanent"
   Why do I mention it
   Can easily construct equivalent weighted instance from unweighted
14. Our branching strategy
   Better but more complicated ones exist, we have implemented a better one after the thesis
15. Merging
   How, why?
   Mention zero-edges, but not in-depth.

## Data Reduction Rules

16. Basic idea of a reduction rule
   Interleaved application
   Correctness
   -> Common Principle: Prove that some edit will definitely be made by an optimal solution, or that
   it will never be made by an optimal solution; then take that edit now
   Additionally: Want to be able to go from a solution for the resulting instance to one for the
   original instance in practice
17. Crit Clique Def, when it is used
   <-->
   never split by optimal solution, thus can merge to get a weighted graph
18. Rules 1--3, quick explanations
   CUT (1: If adding uv costs more than even isolating it completely would, never add uv.)
   --> use this as example: 2: If removing uv costs more than than editing all other edges incident with u, never remove uv.
   CUT (3: If removing uv costs more than isolating u and v from every other node, never remove uv.)
19. Rule 4
   Min-cut value is the cheapest possible way of separating C into two or more clusters.
   If even that is more expensive than just making it one isolated cluster, it will never be
   separated by an optimal solution.
   Need some way of determining which Cs to check. When we apply the rule, we try iteratively constructing subsets to test that are likely to work.
20. Induced Costs
   Costs induced by forbidding or setting an edge permanent (merging it)
   icf: If we forbid uv, at some point there may not be any common neighbors anymore.
   icp: If we merge uv, at some point there may not be any non-common neighbors anymore.
   These are respectively the minimal costs to achieve that.
   Conditions: "If we can't afford the costs induced by making one operation, we know we need to do
   the other one"
   <-->
   CUT (Can be made even more effective with added lower bound.)

## Implementation Details & Techniques

21. Graph Storage
   Matrix storage, with alternative tested ideas
   Mask (mentioned further next slide)
   CUT (Floats for Infinities)
22. Merging
   Don't want to resize graph storage, or copy lots of weights around
   -> just toggle mask value to mark vertex as not present
   -> almost free removal, as well as undo (get to that next)
   -> slightly more expensive other operations, as iterating over the graph needs to consider and
   skip the not present ones
23. Undo + Oplog
   Why we want oplogs, how we do them
24. Conflict Tracking
   List of conflicts useful, maintaining it efficiently is a little tricky
   Combination of 3 lists that allow efficient updates, lower bound calc, and fetching a conflict
   Also has rollback

## Results

25. Solved 34 of 100 public test instances
   Quick graph description
   Can see very small graphs all solvable; somewhat random for larger instances
   On right: Even some instances with a lot of edits solved
26. Effectiveness of initial reduction
   More orange -> more reduced
   Works better on larger instances, some are reduced very far

## Outlook & Confusion

27. Some more work (another reduction, better branching, ...)
   With more time, lots of other possibilities: more advanced branching, other reduction techniques
   Parallelization interesting for real-world use cases, but not useful for PACE challenge
   -> solver would be relatively easily serializable though
   PACE submission done; results expected next month

   Thanks! Questions?
