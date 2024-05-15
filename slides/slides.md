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

Topic: find property $(\beta)$

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: May 22, 2024

---

## Property $(\beta)$ for $s=3$

$(\beta)$: stratifications on $s^2\times s \times s$, $s\times s^2 \times s$ and $s \times s \times s^2$ grids.

$D$ has property $\beta$ iff

1. $A$ is of resolution $IV$ or higher.
2. $(B, B', B'') \subseteq \bar{A}$.
3. $(B, B', B'')$ does not contain any interaction column involving two factors from $A$.

---

## Construction of $(\beta)$ for $s=3$

Let $P_0$ consists of $e_3, \dots, e_k$ and all their interactions.

Let $P = (I, P_0)$.

Then, we have

$S = (P, e_1P, e_1^2P, e_2P, e_2^2P, e_1e_2P, e_1^2e_2^2P, e_1e_2^2P, e_1^2e_2P)$

---

## Construction of $(\beta)$ for $s=3$

For $k=4$, $P = (I, e_3, e_3^2, e_4, e_4^2, e_3e_4, e_3^2e_4^2, e_3e_4^2, e_3^2e_4)$

$A = (e_1P, e_1^2P)$

$B = (e_2P, e_2^2P)$

$B' = (e_1e_2P, e_1^2e_2^2P)$

$B'' = (e_1e_2^2P, e_1^2e_2P)$
