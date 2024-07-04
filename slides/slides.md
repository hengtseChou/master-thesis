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

Topic: Construction Algorithm for $\text{SOA}$ of strength 3 with property $\alpha$

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: Jul. 5, 2024

---

### Goal

- We want to find a metric that can measure, or quantify how close a $\text{SOA}$ of strength 3 is to have property $\alpha$, that is, stratification on $s^2\times s^2$ grids in all 2-dims for $s=3$.
- This metric should help us in constructing $\text{SOA}$ of strength 3 with the desired property.

---

### Minimum moment aberration

(from Xu 2003, but with our notations)

With $n$ runs, $m$ factors and $s$ levels, the $p$-th power moment of $D$ is defined by $K_p = (n(n-1)/2)^{-1}\sum_{i=1}^{n}\sum_{j=i+1}^{n}(\delta(x_i, x_j))^p$,

where $\delta(x_i, x_j) = \sum_{k=1}^m{1}(x_{ik} = x_{jk})$.

$m - \delta(x_i, x_j)$ is known as the Hamming distance between $x_i$ and $x_j$.

---

### Minimum moment aberration

(from Xu 2003)

The power moments measure the similarity among runs.

The first and second power moments measure the average and variance of the similarity among runs.

Minimizing the power moments makes runs be as dissimilar as possible.

---

### Minimum moment aberration

These lower bounds can be used to check if a design is OA.

- $K_1(D) \geq(m(n-s))/((n-1)s)$, with equality iff $D$ is $\text{OA}(1)$.
- $K_2(D) \geq(nm(n+s-1) - (ms)^2)/((n-1)s^2)$, with equality iff $D$ is $\text{OA}(2)$.
- $K_3(D) \geq(nm(m^2+3ms+s^2-3m-3s+2)-(ms)^3)/((n-1)s^3)$, with equality iff $D$ is $\text{OA}(3)$.

---

### $J_2$-optimality

(Xu 2000)

Now let $\delta_{i, j}(D) = \sum_{k=1}^mw_k\delta(x_{ik}, x_{jk})$, where $\delta(x,y)=1$ if $x=y$ and 0 otherwise.

Define $J_2(D) = \sum_{i=1}^{n}\sum_{j=i+1}^{n}\left[\delta_{i,j}(D)\right]^2$.

A design is called $J_2$-optimal if it minimizes $J_2$.

---

### $J_2$-optimality

For a mixed level design $D$ with each column having $s_k$ levels,

$L(m) = 2^{-1}\left[(\sum_{k=1}^mns_k^{-1}w_k)^2 + (\sum_{k=1}^m(s_k-1)(ns_k^{-1}w_k)^2) - n(\sum_{k=1}^mw_k)^2\right].$

We have $J_2(D)\geq L(m)$, where the equality holds iff $D$ is an $\text{OA}$ of strength 2.

The $J_2$-optimality is a special case of the minimum moment aberration.

---

### The construction algorithm

The algorithm is aimed to generate mixed level $\text{OA}$ and $\text{NOA}$.

Main idea: sequentially add columns to an existing design.

(1) Consider adding a column $c=(c_1, \dots, c_n)'$ to $D$.

Let $D_+$ be the new $n\times(m+1)$ design.

If $c$ has $s_p$ levels and weight $w_p$, then $\delta_{i, j}(D_+) = \delta_{i, j}(D)+\delta_{i, j}(c)$,

where $\delta_{i, j}(c) = w_p\delta(c_i, c_j)$.

---

### The construction algorithm

Moreover,

$J_2(D_+) = J_2(D) + 2\sum_{i=1}^n\sum_{j=i+1}^n\delta_{i,j}(D)\delta_{i,j}(c) + (n/2)w_p^2(s_p/n-1)$

if the added column is balanced.

---

### The construction algorithm

(2) Consider switching a pair of symbols in the added column.

Suppose the symbols in rows $a$ and $b$ of the added column are distinct, i.e., $c_a \neq c_b$.

If these two symbols are exchanged, then all $\delta_{i,j}(c)$ are unchanged except that $\delta_{a_j}(c) = \delta_{j, a}(c)$ and $\delta_{b,j}(c) = \delta_{j,b}(c)$ are switched for $j \neq a, b$.

---

### The construction algorithm

Hence, $J_2(D_+)$ is reduced by $2S(a,b)$, where

$S(a, b) = -\sum_{1\leq j\neq a,b\leq n}\left[\delta_{a,j}(D) - \delta_{b,j}(D)\right]\left[\delta_{a,j}(c) - \delta_{b,j}(c)\right]$

For each candidate column, the algorithm searches all possible interchanges and makes an interchange which reduces $J_2$ most.

---

### The construction algorithm

The algorithm is given as follows:

1. For $p=1,\dots,n$, compute the lower bound $L(p)$.
2. Specify an initial design $D$ with two columns: $(0, \dots, 0, 1, \dots , 1, \dots , s_1 − 1, \dots , s_1 − 1)$ and $(0, \dots , s_2 − 1, 0, \dots , s_2 − 1, \dots , 0,\dots , s_2 − 1)$.
   Compute $\delta_{i,j}(D)$ and $J_2(D)$. If $J_2(D) = L(2)$, let $m_0 = 2$ and $T = T_1$; otherwise, let $m_0 = 0$ and $T = T_2$.

---

### The construction algorithm

3. For $p=3, \dots, m$. do the following:

(a) Randomly generate a balanced $s_p$-level column $c$. Compute $J_2(D_+)$. If $J_2(D_+)=L(p)$, go to (d).

(b) For all pairs of row $a$ and $b$ with distinct symbols, compute $S(a, b).$ Choose a pair of rows with largest $S(a, b)$ and exchange the symbols in rows $a$ and $b$ of column $c$. Reduce $J_2(D_+)$ by $2S(a,b)$. If $J_2(D_+)=L(p)$, go to (d); otherwise, repeat this procedure until no further improvement is made.

---

### The construction algorithm

(c) Repeat (a) and (b) $T$ times and choose a column $c$ that produces the smallest $J_2(D_+)$.

(d) Add column $c$ as the $p$-th column of $D$, let $J_2(D)=J_2(D_+)$ and update $\delta_{i,j}(D)$. If $J_2(D_+)=L(p)$, let $m_0 = p$; otherwise, let $T=T_2$.

---

### The construction algorithm

4. Return the final $n\times m$ design $D$, of which the first $m_0$ columns form an $\text{OA}$.

---

### Issues

how to make it work for soa 3 with property alpha
