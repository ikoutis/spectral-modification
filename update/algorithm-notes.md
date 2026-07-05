# Algorithm Notes: Spectral Maximizers and Cut-Preserving Rewiring

These notes translate `spectral-maximizer.tex` into implementable routines.
They are written for a future Python prototype, but the structure also maps
cleanly onto the existing MATLAB code in `NeurIPS2019/`.

## Core Objects

- `G`: connected weighted undirected graph on terminals `V`.
- `T`: terminal-Steiner hierarchy with nodes `V union I`.
- `H_T`: Schur complement of `T` onto `V`.
- `B`: connected demand graph for generalized eigenvalues; use `K_d` for
  normalized cuts.
- `H_hat`: sparse sampled approximation to `H_T`.

## Public API

```text
build_maximizer(G, method="hca", seed=None) -> MaximizerState
apply_maximizer(state, x) -> L_H x
sample_maximizer_edges(state, eps=0.1, budget=None, seed=None) -> EdgeSample
generalized_embedding(operator, B, k) -> eigenvalues, eigenvectors
cut_certificate(G, H_or_sample, cuts) -> distortion report
spectral_certificate(state, H_hat, probes, B) -> Rayleigh/spectral report
```

## Exact Implicit Maximizer

1. Build or load a terminal-Steiner hierarchy `T`.
2. Form sparse Laplacian blocks:
   - `A = L_II`
   - `C = L_IV`
   - `D = L_VV`
3. Factor or prepare a tree solver for `A`.
4. Implement:

```text
apply_maximizer(x):
    y = solve(A, C @ x)
    return D @ x - C.T @ y
```

5. Use this operator in LOBPCG or Lanczos for `L_H x = lambda L_B x`.

Certification:

- Check `x.T @ apply_maximizer(x) >= 0` on random probes.
- Check constants vanish: `apply_maximizer(ones) ~= 0`.
- For sampled cuts `S`, compare `cut_H(S)` from the quadratic form against
  `cut_G(S)`.

## Sparse Edge Sampler

The target guarantee is:

```text
(1 - eps) H_T <= H_hat <= (1 + eps) H_T
```

Initial prototype stages:

1. Exact star-mesh elimination for small graphs.
   - Eliminate each Steiner node.
   - Add clique weights `c_i c_j / sum(c)`.
   - Coalesce parallel terminal edges.
2. Naive sampled star-mesh for medium graphs.
   - Sample clique edges proportional to exact clique weight.
   - Reweight by inverse probability.
   - Track variance and empirical spectral error.
3. Provable sampler.
   - Replace naive probabilities by leverage-score/effective-resistance
     estimates from Schur-complement sparsification.
   - Use Lee-Peng-Spielman or Li-Schild style routines as the proof target.

Returned object:

```text
EdgeSample:
    edges: [(u, v, weight)]
    eps_target
    seed
    certificate:
        cut_distortion_quantiles
        rayleigh_distortion_quantiles
        lambda2_before_after
```

## Adding Edges Back

Replacement mode:

```text
M = H_hat
```

Use when the goal is the cleanest theorem and strongest Cheeger certificate.
Evaluate returned cuts in `G`.

Augmentation mode:

```text
M_eta = G + eta * H_hat
```

Use when original graph edges must remain visible, especially for GNN message
passing.  The manuscript gives a conservative certificate:

```text
phi(M_eta, B) <= ((h + eta(1 + eps)) / (eta(1 - eps))) alpha h lambda2(M_eta, B)
```

Practical default:

- Start with `eta = 1 / h` so the maximizer component is visible but not
  overwhelming.
- Tune `eta` by monitoring `lambda2`, sampled cut distortion, and downstream
  clustering/GNN validation.

## Tree-Pack Variant

This is the bridge to the current MATLAB method.

Existing baseline:

- `energy_td.m` computes an approximate second eigenvector.
- It reweights each edge by `w_uv (z_u - z_v)^2`.
- It repeatedly extracts maximum spanning trees, discounts selected edges,
  and constructs tree maximizers.

Provable variant:

1. Select trees `T_1, ..., T_k` using either:
   - low-stretch tree samples,
   - oblivious-routing tree distribution,
   - high-energy maximum spanning trees with discounting.
2. For each tree, build a tree hierarchy and Schur maximizer `H_j`.
3. Return:

```text
M = G + sum_j eta_j H_j
```

Guaranteed immediately:

- `M >= G` spectrally, so generalized eigenvalues cannot decrease.
- `cut_M(S) <= (1 + sum_j eta_j alpha_j) cut_G(S)` for every cut.

Still conjectural:

- A small energy-guided tree pack approximates the full HCA maximizer on the
  low-eigenvector subspace.

## Experiments

### Mathematical sanity checks

1. Path graph:
   - Verify `lambda2(G) = Theta(n^-2)`.
   - Build binary-tree hierarchy.
   - Verify `lambda2(H) ~= 1 / (n log n)` up to constants.
2. Expander:
   - Verify modification does not create large cut distortion.
   - Verify low eigenvalues remain within a small factor.
3. Guattery-Miller bad cases:
   - Compare sweep cuts before and after modification.

### Numerical certificate checks

For each graph and sampler:

- Sample random cuts, sweep cuts, singleton cuts, and hierarchy cuts.
- Report max/median distortion for `cut_H / cut_G`.
- Estimate Rayleigh distortion of `H_hat` against implicit `H`.
- Track `lambda2(G,B)`, `lambda2(H_hat,B)`, and best sweep cut.

### GNN rewiring checks

Compare:

- original graph,
- FoSR-style spectral rewiring,
- effective-resistance rewiring,
- maximizer replacement,
- maximizer augmentation with separate edge channel.

Metrics:

- validation/test accuracy,
- total effective resistance estimate,
- spectral gap,
- sampled cut distortion,
- oversmoothing proxy from pairwise representation collapse.

## Files to Add in a Future Prototype

```text
update/prototype/
    graph_generators.py
    hierarchy.py
    schur.py
    sample_edges.py
    certificates.py
    experiments_path.py
    experiments_bad_cases.py
    experiments_gnn_rewiring.py
```

Keep the prototype separate from the original MATLAB code until the proof
interfaces stabilize.
