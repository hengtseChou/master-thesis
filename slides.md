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

Topic: Property $\alpha$ for $\text{SOA}$ of strength 3 with 3 levels

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: Mar 13, 2024

---

## Goal

- Make $\text{SOA}$ of strength 3 with 3 levels having property $\alpha$, that is, **stratification on $s^2 \times s^2$ grids in all two dimensions.**

---

## Recap

**Lemma 1. (from Shi and Tang 2020)**

$D: SOA(n, m, s^3, 3)$
$A=(a_1, \dots, a_m)$
$B=(b_1, \dots, b_m)$
$C=(c_1, \dots, c_m)$

$D$ exists if and only if $A$, $B$ and $C$ exist such that $(a_i, a_j, a_u)$, $(a_i, a_j, b_j)$ and $(a_i, b_i, c_i)$ are $OA(n, 3, s, 3)s$ for all $i\neq j$, $i\neq u$ and $j \neq u$.

They are linked through $D = s^2 A + sB +C$.

---

## Recap

**Proposition 1. (i) (from Shi and Tang, 2020)**

An $\text{SOA}(n, m, s^3, 3)$ as characterized in Lemma 1 through $A$, $B$ and $C$ has property $\alpha$ if and only if $(a_i, b_i, a_j, b_j)$ is an $OA(n, 4, s, 4)$ for all $i \neq j$.

---

## Recap

**Theorem 1. (from Shi and Tang, 2020)**

If an $\text{SOA}(n, m, s^3, 3)$ for $s=2$ is to be constructed using regular $A$, $B$, and $C$ with their columns selected from a saturated design $S$, then it has property $\alpha$ if and only if:

1. $A$ is of resolution $IV$ or higher
2. $(A, B, B')$ has resolution $III$ or higher, that is, no repeated columns, where $B' = (b'_1, \dots, b'_m)$ with $b'_j = a_jb_j$

---

## Breaking down

We first focus on the first two conditions of Lemma 1 and Proposition 1 (i):

1. $A$ is of resolution $IV$ $\longleftrightarrow$ $(a_i, a_j, a_u)$ is $\text{OA}(n, 3, s, 3)$
2. $(a_i, b_i, a_j, b_j)$ being $\text{OA}(n, 4, s, 4)$ $\longrightarrow$ $(a_i, a_j, b_j)$ being $\text{OA}(n, 3, s, 3)$

---

## Breaking down

For $s=2$, $(a_i, b_i, a_j, b_j)$ having strength 4

$\longrightarrow$ Four columns are independent, orthogonal

$\longrightarrow$ No defining words among them

$\longrightarrow$ $a_ib_ia_jb_j \neq I$

$\longrightarrow$ $a_ib_i \neq a_jb_j$

$\longrightarrow$ $(A, B, B')$ having no repeated columns can assure this

---

## Breaking down

Finally, to choose $c_j:$

$\longrightarrow$ Take $c_j$ to be any column other than $a_j$, $b_j$ and $a_jb_j$

$\longrightarrow$ $(a_j, b_j, c_j)$ is $\text{OA}(n, 3, s, 3)$

$\longrightarrow$ All requirements from Lemma 1 and Proposition 1 (i) are satisified

---

## Same idea goes for $s=3$

- $A$ still need to be of resolution $IV$ or higher for $(a_i, a_j, a_u)$ being $\text{OA}(n, 3, s, 3)$
- $(a_i, b_i, a_j, b_j)$ is strength 4 $\longrightarrow I \neq a_ib_ia_jb_j$ and $a_ib_ia_jb_j^2$
- It means $a_ib_i \neq a_jb_j$ and $a_ib_i \neq a_jb_j^2$
- $(A, B, B', B'')$ having no repeated columns can assure this, where $b_j' = a_jb_j$ and $b_j'' = a_jb_j^2$

---

## To sum up

If an $\text{SOA}(n, m, s^3, 3)$ for $s=3$ is to be constructed using regular $A$, $B$, and $C$ with their columns selected from a saturated design $S$, then it has property $\alpha$ if and only if:

1. $A$ is of resolution $IV$ or higher
2. $(A, B, B', B'')$ has resolution $III$ or higher where $B' = (b'_1, \dots, b'_m)$ with $b'_j = a_jb_j$, and $B'' = (b''_1, \dots, b''_m)$ with $b''_j = a_jb_j^2$.
