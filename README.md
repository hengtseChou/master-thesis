# SOA of strength three with 3 level designs

This work is extended from [Construction results for strong orthogonal arrays of strength three (Shi and Tang, 2020)](https://projecteuclid.org/journals/bernoulli/volume-26/issue-1/Construction-results-for-strong-orthogonal-arrays-of-strength-three/10.3150/19-BEJ1130.full).

## Background

An orthogonal array with strength $t$ is that for every selection of $t$ columns, the entries in each row restricted to these columns appear the same number of times.

An $n \times m$ matrix with entries from $\{0, 1,...,s^t − 1\}$ is called an $\text{SOA}$ of $n$ runs, $m$ factors, $s^t$ levels and strength $t$ if any subarray of $g$ columns for any $g$ with $1\leq g \leq t$ can be collapsed into an $\text{OA}(n,g,s^{u_1} \times \cdots \times s^{u_g} ,g)$ for any positive integers $u_1, \dots, u_g$ with $u_1 +\dots+u_g = t$ , where collapsing $s^t$ levels into $s^{u_j}$ levels is according to $\left[a/s^{t−u_j} \right]$ for $a = 0, 1,\dots,s^t − 1$.

SOAs of strength three are most useful, since SOAs of strength two are no more space-filling than ordinary orthogonal arrays of strength two and SOAs of strength four or higher are prohibitively expensive.

## Goal

> An $\text{SOA}(n,m,s^3,3)$, say $D$, exists if and only if there exist three arrays $A = (a_1,...,a_m)$, $B = (b_1,...,b_m)$, and $C = (c_1,...,c_m)$ such that $(a_i ,a_j ,a_u)$, $(a_i,a_j ,b_j )$, and $(a_i,b_i,c_i)$ are $\text{OA}(n, 3,s,3)$ s for all $i \neq j$, $i \neq u$, and $j \neq u$. These arrays are related through $D = s^2A + sB + C$.

An $\text{SOA}(n, m, s^3, 3)$ can achieve stratification on $s\times s \times s$ in all 3-dims, $s \times s^2$ and $s^2 \times s$ in all 2-dims.

The goal is to construct certain thrength-three SOAs that enjoy some of the space-filling properties that only strength-four SOAs can offer, which are given by the following notations:

- $(\alpha)$ stratification on $s^2 \times s^2$ grids in all 2-dims.
- $(\beta)$ stratification on $s^2 \times s \times s$, $s \times s^2 \times s$ and $s \times s \times s^2$ grids in all 3-dims.
- $(\gamma)$ stratification on $s^3 \times s$ and $s\times s^3$ grids in all 2-dims.

To achieve this goal, we have a very useful proposition:

> An $\text{SOA}(n,m,s^3,3)$, as characterized in above through $A$, $B$, and $C$, has:
>
> - property $\alpha$ if and only if $(a_i,b_i,a_j,b_j)$ is an $\text{OA}(n, 4,s,4)$ for all $i \neq j$,
> - property $\beta$ if and only if $(a_i,a_j,a_u,b_u)$ is an $\text{OA}(n, 4,s,4)$ for all $i \neq j$, $i \neq u$, and $j \neq u$,
> - property $\gamma$ if and only if $(a_i,a_j,b_j,c_j)$ is an $\text{OA}(n, 4,s,4)$ for all $i \neq j$.

## Design with property $\alpha$

In Shi and Tang's, a theorem for property $\alpha$ is derived from the proposition:

> If an $\text{SOA}(n, m, 8, 3)$ is to be constructed using regular $A$, $B$, and $C$ with their columns selected from a saturated design $S$, then it has property $\alpha$ if and only if $A$ is of resolution IV or higher and $(A,B,B')$ has resolution III or higher, where $B' = (b'_1, \dots, b'_m)$ with $b'_j = a_j \cdot b_j$.

A recursive construction of the required designs $A$ and $B$ is also given:

$A_{k+2} = (A_k,e_{k+1}A_k,e_{k+2}A_k,e_{k+1}e_{k+2}A_k)$

$B_{k+2} = (B_k,e_{k+2}B_k,e_{k+1}e_{k+2}B_k,e_{k+1}B_k)$

with the assumption that $A$ is of resolution $IV$ or higher.

### Current work

In our work, a revised theorem is proposed:

> If an $\text{SOA}(n, m, 27, 3)$ is to be constructed using regular $A$, $B$, and $C$ with their columns selected from a saturated design $S$, then it has property $\alpha$ if and only if $A$ is of resolution IV or higher and $(A,B,B', B'')$ has resolution III or higher, where $B' = (b'_1, \dots, b'_m)$ with $b'_j = a_j \cdot b_j$ and $B'' = (b''_1, \dots, b''_m)$ with $b''_j = a_j \cdot b^2_j$.

A permutation of $k=2$:

| $\alpha$ | $\beta$  | $\alpha\cdot\beta$ | $\alpha\cdot\beta^2$ |
| :------: | :------: | :----------------: | :------------------: |
|   $1$    |   $2$    |        $12$        |        $12^2$        |
|  $1^2$   |  $2^2$   |      $1^22^2$      |        $1^22$        |
|   $2$    |  $1^2$   |       $1^22$       |         $12$         |
|  $2^2$   |   $1$    |       $12^2$       |       $1^22^2$       |
|   $12$   |  $12^2$  |       $1^2$        |        $2^2$         |
| $1^22^2$ |  $1^22$  |        $1$         |         $2$          |
|  $12^2$  | $1^22^2$ |        $2$         |        $1^2$         |
|  $1^22$  |   $12$   |       $2^2$        |         $1$          |

A grouping of $k=4$:

| $\alpha$  |  $\beta$  | $\alpha\cdot\beta$ | $\alpha\cdot\beta^2$ |
| :-------: | :-------: | :----------------: | :------------------: |
|   $14$    |   $23$    |       $1234$       |      $12^23^24$      |
|  $1^24$   |  $2^23$   |     $1^22^234$     |      $1^223^24$      |
|   $24$    |  $1^23$   |      $1^2234$      |       $123^24$       |
|  $2^24$   |   $13$    |      $12^234$      |     $1^22^23^24$     |
|   $123$   |  $12^24$  |      $1^234$       |      $2^234^2$       |
| $1^22^23$ |  $1^224$  |       $134$        |       $234^2$        |
|  $12^23$  | $1^22^24$ |       $234$        |      $1^234^2$       |
|  $1^223$  |   $124$   |      $2^234$       |       $134^2$        |

This gives us the desired property $\alpha$, with the maximum $m=8$ when $k=4$.

Extend the grouping to $k=6$ based on $k=4$:

$A_6 = (A_4, e_5A_4, e_5^2A_4, e_6A_4, e_6^2A_4, e_5e_6A_4, e_5^2e_6^2A_4, e_5e_6^2A_4, e_5^2e_6A_4)$

$B_6 = (B_4, e_6B_4, e_6^2B_4, e_5^2B_4, e_5B_4, e_5e_6^2B_4, e_5^2e6B_4, e_5^2e_6^2B_4, e_5e_6B_4)$

### Unresolved issues

- Current grouping of $k=6$ does not have `s111` stratification, since the algorithm inevitably select 3 A's, which forms $I$.
- Unable to prove that maximum $m$ is 8 when $k=4$.
- Unable to find the permutation of $k=3$, nor the grouping of $k=5$.

## Design with property $\beta$

In Shi and Tang's, a theorem is derived for property $\beta$:

> If an $\text{SOA}(n, m, 8, 3)$ is to be constructed using regular $A$, $B$, and $C$, then it has property $\beta$ if and only if $A$ is of resolution IV or higher, $(B, B') \subseteq \bar{A}$, and $(B, B')$ does not contain any interaction column involving two factors from $A$, where $\bar{A} = S \setminus A$.

A construction of the required designs $A$ and $B$ is also given:

$P_0: $e_3, \dots, e_k$ and all of their interactions. $P = (I, P_0)$.

Then, $S = (P_0, e_1 P_0, e_2 P_0, e_1 e_2 P_0).

We can have $A = e_1 P_0$ and $B = e_2 P_0$, so that $B' = e_1 e_2 P_0$.

### Current work

In our work, a revised theorem is proposed:

> If an $\text{SOA}(n, m, 27, 3)$ is to be constructed using regular $A$, $B$, and $C$, then it has property $\beta$ if and only if $A$ is of resolution IV or higher, $(B, B', B'') \subseteq \bar{A}$, and $(B, B', B'')$ does not contain any interaction column involving two factors from $A$, where $\bar{A} = S \setminus A$.

A construction of the required designs $A$ and $B$ is also given:

$P_0$: $e_3, \dots, e_k$ and all of their interactions. $P = (I, P_0)$.

Then, $S = (P_0, e_1 P_0, e_1^2 P_0, e_2 P_0, e_2^2 P_0, e_1 e_2 P_0, e_1^2 e_2^2 P_0, e_1 e_2^2 P_0, e_1^2 e_2 P_0)$.

We can have $A = (e_1 P_0, e_1^2 P_0)$ and $B = (e_2 P_0, e_2^2 P_0)$, so that $B' = (e_1 e_2 P_0, e_1^2 e_2^2 P_0)$ and $B''=(e_1 e_2^2 P_0, e_1^2 e_2 P_0)$.

### Unresolved issues

## Design with property $\gamma$
