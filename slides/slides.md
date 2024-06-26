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

Date: Jun. 26, 2024

---

### Goal

- We want to find a metric that can measure, or quantify how close a design is to have property $\alpha$, that is, stratification on $s^2\times s^2$ grids in all 2-dims.

---

### Moment aberration

With $n$ runs, $m$ factors and $s$ levels, moment aberrations are denoted as

$M(D_{n\times m}) = (M_1, M_2, \dots, M_p)$, where

$M_k = \sum_{i=1}^{n=1}\sum_{j=i+1}^{n}(p - d_H(x_i, x_j))^k$, and

$d_H(x_i, x_j) = \sum_{l=1}^p{1}(x_{il} \neq x_{jl})$ being Hamming distance.
