---
marp: true
theme: gaia
paginate: true
color: black
backgroundImage: url('https://i.imgur.com/BgTCqJd.png')
style: |
  section {
    padding-top: 150px;
    padding-left: 200px;
    padding-right: 150px;
  }
  p {
    font-size: 26px;
    line-height: 1.5;
  } 
  li {
    font-size: 26px;
    line-height: 1.5;
  }
  code {
    background-color: #dbdbdb;
    color: black;
  }
  table {
    font-size: 24px;
  }
  section.cover h1 {
    padding-top: 60px;
    padding-bottom: 10px;
  }
  section.cover br {
    font-size: 60px;
  }
  section.cover p {
    line-height: 0.8
  }
math: mathjax
---

<!-- _class: cover -->

# Weekly Meeting

Topic: Issues regarding grouping and permutations

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: Apr 24, 2024

---

## Issues

1. Find the permutation for $k=2$ with group $\alpha$ being resolution $III$, so that design $A$ would be of resolution $IV$.
2. How to get the grouping for $k=6$, based on the grouping for $k=4$.
3. Grouping for $k=5$, or permutation for $k=3$ if feasible.

---

## A grouping for $k=4$

| $\alpha$  |  $\beta$  | $\alpha\cdot\beta$ | $\alpha\cdot\beta^2$ |
| :-------: | :-------: | :----------------: | :------------------: |
|   $13$    |   $24$    |       $1234$       |      $12^234^2$      |
|  $1^23$   |  $2^24$   |     $1^22^234$     |      $1^2234^2$      |
|   $23$    |  $1^24$   |      $1^2234$      |       $1234^2$       |
|  $2^23$   |   $14$    |      $12^234$      |     $1^22^234^2$     |
|   $123$   |  $12^24$  |      $1^234$       |      $2^234^2$       |
| $1^22^23$ |  $1^224$  |       $134$        |       $234^2$        |
|  $12^23$  | $1^22^24$ |       $234$        |      $1^234^2$       |
|  $1^223$  |   $124$   |      $2^234$       |       $134^2$        |

---

## Notes

**The number of effects:**

- $k=2$: 4
- $k=3$: 13 (=4x3+1)
- $k=4$: 40 (=13x3+1)
- $k=5$: 121
- $k=6$: 364

---

## Notes

**Formula:**

1. $\sum_{i=1}^kC_i^k2^{i-1}$
2. $\frac{3^k-1}{2}$

---

## After meeting

This can work for $m=8$:

| $\alpha$  |  $\beta$  | $\alpha\cdot\beta$ | $\alpha\cdot\beta^2$ |
| :-------: | :-------: | :----------------: | :------------------: |
|   $24$    |   $13$    |       $1234$       |      $1^2234^2$      |
|  $2^24$   |  $1^23$   |     $1^22^234$     |      $12^234^2$      |
|  $1^24$   |   $23$    |      $1^2234$      |     $1^22^234^2$     |
|   $14$    |  $2^23$   |      $12^234$      |       $1234^2$       |
|   $123$   |  $12^24$  |      $1^234$       |      $2^234^2$       |
| $1^22^23$ |  $1^224$  |       $134$        |       $234^2$        |
|  $12^23$  | $1^22^24$ |       $234$        |      $1^234^2$       |
|  $1^223$  |   $124$   |      $2^234$       |       $134^2$        |

---

## Todos

1. Check if $m>8$ is possible, by trying different mutiplication to the permutation.
2. Dig into the grouping algorithm when $s=2$, and think about if it can be extended to $s=3$.
