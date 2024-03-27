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
  table {
    font-size: 26px;
  }
  th {
    background-color: #000000;
  }
  td {

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

Topic: Property $\alpha$ for $\text{SOA}$ of strength 3 with $s = 3$

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: Mar 27, 2024

---

## Goal

- Find similar grouping scheme and permutations to [Wu, C.-F.J. (1989)](https://projecteuclid.org/journals/annals-of-statistics/volume-17/issue-4/Construction-of-2m4n-Designs-via-a-Grouping-Scheme/10.1214/aos/1176347399.full) for $s=3$.

---

## Permutations

This illustrate the idea under $s=2$.

- $B_k$: all effects for a full factorial of $k$ independent factors plus $I$.
- All the elements in $B_k$ can be expressed as $w_i = w_{\pi(i)} \cdot w_{r(i)}$.
- Then, the exclusive sets $(w_{\pi(i)}\cdot (k+1))$, $(w_{r(i)}\cdot (k+2))$, $(w_i\cdot (k+1)(k+2))$, each of which is of the form $(\alpha, \beta, \alpha \cdot \beta)$ for $k=4$.

---

## Permutations

**Example.**
![w:750](image.png)

---

## For $s=3$

We want to find the grouping scheme of $(\alpha, \beta, \alpha\cdot\beta. \alpha\cdot\beta^2)$ for $s^2 \times s^2$ stratification property, which requires the design $A$ has resolution $IV$ and $(A, B, B', B'')$ has resolution $III$.

The major difference is that each effect in a 3 level design **contains 2 components**.

Therefore, instead the permutations of _all effects_, we want to find the permutations of _all components_.

---

## For $s=3$

| $\alpha$ | $\beta$  | $\alpha\cdot\beta$ | $\alpha\cdot\beta^2$ |
| :------: | :------: | :----------------: | :------------------: |
|   $1$    |   $2$    |        $12$        |        $12^2$        |
|  $1^2$   |  $2^2$   |      $1^22^2$      |        $1^2$         |
|   $2$    |  $1^2$   |       $1^22$       |         $12$         |
|  $2^2$   |   $1$    |       $12^2$       |       $1^22^2$       |
|   $12$   |  $12^2$  |       $1^2$        |        $2^2$         |
| $1^22^2$ |  $1^22$  |        $1$         |         $2$          |
|  $12^2$  | $1^22^2$ |        $2$         |        $1^2$         |
|  $1^22$  |   $12$   |       $2^2$        |         $1$          |

---

## For $s=3$

| $\alpha$  |  $\beta$  | $\alpha\cdot\beta$ | $\alpha\cdot\beta^2$ |
| :-------: | :-------: | :----------------: | :------------------: |
|   $13$    |   $24$    |       $1234$       |      $12^234^2$      |
|  $1^23$   |  $2^24$   |     $1^22^234$     |      $1^234^2$       |
|   $23$    |  $1^24$   |      $1^2234$      |       $1234^2$       |
|  $2^23$   |   $14$    |      $12^234$      |     $1^22^234^2$     |
|   $123$   |  $12^24$  |      $1^234$       |      $2^234^2$       |
| $1^22^23$ |  $1^224$  |       $134$        |       $234^2$        |
|  $12^23$  | $1^22^24$ |       $234$        |      $1^234^2$       |
|  $1^223$  |   $124$   |      $2^234$       |       $134^2$        |

---

## For $s=3$

... adding up another group $(1, 2, 12, 12^2)$, this gives us the grouping scheme $(A, B, B', B'')$ we desired.

Note that $(3, 4, 34, 34^2)$ cannot be included, otherwise it will not properly form a design A of resolution $IV$.

_Side note: res. IV = cannot form I with any 3 elements._

---

## Next ...

1. Generate $D = 9A+3B+C.$
2. Check if $D$ is $\text{SOA}$ of strength 3.
3. Check if $D$ has $\alpha$ property.
4. Find the permutations for $k=3$.
