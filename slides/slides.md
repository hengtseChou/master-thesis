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

## Issue

- Since $1$ is equivalent to $1^2$, $13 \times 1^23 \times 1=I$.
- It does not have resolution $IV$. The final $D$ should pass the check on `s22` and `s111`.
- Need to try other permutations.
- Maybe $m=10$ can be found.

---

## Other things to do

- How to find the grouping for $k=6$ by utilizing the grouping for $k=4$
- Since we need $A$ to be of res. $IV$, the grouping of $k=5$ is really not of interest. Find the grouping of $k=3$, if the permutation of $k=3$ is not feasible.
