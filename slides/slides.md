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
  section.cover p {
    line-height: 0.8;
  }
math: mathjax
---

<!-- _class: cover -->

# Weekly Meeting

Topic: Develop a criteria that is corresponding to property $\alpha$

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: Jul. 5, 2024

---

### Goal

- We want to find a metric that can measure, or quantify how close a design is to have property $\alpha$, that is, stratification on $s^2\times s^2$ grids in all 2-dims.

---

### p-th power moment

(from Xu 2003, but with our notations)

With $n$ runs, $m$ factors and $s$ levels, the power moments of $D$ are denoted as $M(D_{n\times m}) = (M_1, M_2, \dots, M_p)$,

where $M_k = (n(n-1)/2)^{-1}\sum_{i=1}^{n}\sum_{j=i+1}^{n}(p - d_H(x_i, x_j))^k$,

and $d_H(x_i, x_j) = \sum_{l=1}^p{1}(x_{il} \neq x_{jl})$ is known as the Hamming distance between $x_i$ and $x_j$.

---

### p-th power moment

(from Xu 2003)

The power moments measure the similarity among runs.

The first and second power moments measure the average and variance of the similarity among runs.

Minimizing the power moments makes runs be as dissimilar as possible.

---

<!-- _hide: true -->

### Minimum moment aberration

These lower bounds can be used to check if a design is OA.

- $M_1(D) \geq(m(n-s))/((n-1)s)$, with equality iff $D$ is $\text{OA}(1)$.
- $M_2(D) \geq(nm(n+s-1) - (ms)^2)/((n-1)s^2)$, with equality iff $D$ is $\text{OA}(2)$.
- $M_3(D) \geq(nm(m^2+3ms+s^2-3m-3s+2)-(ms)^3)/((n-1)s^3)$, with equality iff $D$ is $\text{OA}(3)$.
