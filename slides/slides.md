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

Topic: Property $\alpha$ for $\text{SOA}$ of strength 3 with $s = 3$

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: Apr 10, 2024

---

## A grouping for $k=4$

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
|    $1$    |    $2$    |        $12$        |        $12^2$        |

---

## Issue

- Since $1$ is equivalent to $1^2$, $13 \times 1^23 \times 1=I$.
- It does not have resolution $IV$. The final $D$ should pass the check on `s22` and `s111`.
- Need to try other permutations.
- Maybe $m=10$ can be found.

---

## Other things to do

- How to find the grouping for $k=6$ by utilizing the grouping for $k=4$
- Since we need $A$ to be of res. $IV$, the grouping of $k=5$ is really not of interest. Find the grouping of $k=3$, if the permutation of $k=3$ is not feasible.
