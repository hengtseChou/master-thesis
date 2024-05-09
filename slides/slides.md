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

Topic: validate $k=6$; find property $(\beta)$ and $(\gamma)$

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: May 8, 2024

---

## A grouping for $k=4$

| $\alpha$  |  $\beta$  | $\alpha\cdot\beta$ | $\alpha\cdot\beta^2$ |
| :-------: | :-------: | :----------------: | :------------------: |
|   $14$    |   $23$    |       $1234$       |      $12^234^2$      |
|  $1^24$   |  $2^23$   |     $1^22^234$     |      $1^2234^2$      |
|   $24$    |  $1^23$   |      $1^2234$      |       $1234^2$       |
|  $2^24$   |   $13$    |      $12^234$      |     $1^22^234^2$     |
|   $123$   |  $12^24$  |      $1^234$       |      $2^234^2$       |
| $1^22^23$ |  $1^224$  |       $134$        |       $234^2$        |
|  $12^23$  | $1^22^24$ |       $234$        |      $1^234^2$       |
|  $1^223$  |   $124$   |      $2^234$       |       $134^2$        |

---

## $k=4 \rightarrow k=6$

Assume we have $A_k$, $B_k$, $B_k'$, $B_k''$.

![equation](equation1.png)

<!--
$$
A_{k+2} = (A_k, A_ke_{k+1}, A_ke_{k+1}^2, A_ke_{k+2}, A_ke_{k+2}^2, A_ke_{k+1}e_{k+2},  A_ke_{k+1}^2e_{k+2}^2,  A_ke_{k+1}e_{k+2}^2,  A_ke^2_{k+1}e_{k+2})
$$

$$
B_{k+2} = (B_k, B_ke_{k+2}, B_ke_{k+2}^2, B_ke_{k+1}e_{k+2},  B_ke_{k+1}^2e_{k+2}^2,  B_ke_{k+1}e_{k+2}^2,  B_ke^2_{k+1}e_{k+2}, B_ke_{k+1}, B_ke_{k+1}^2)
$$

$$
B'_{k+2} = (B'_k, B'_ke_{k+1}e_{k+2},  B'_ke_{k+1}^2e_{k+2}^2,  B'_ke_{k+1}e_{k+2}^2,  B'_ke^2_{k+1}e_{k+2}, B'_ke_{k+1}, B'_ke_{k+1}^2, B'_ke_{k+2}, B'_ke_{k+2}^2)
$$

$$
B''_{k+2} = (B''_k,  B''_ke_{k+1}e_{k+2}^2,  B''_ke^2_{k+1}e_{k+2}, B''_ke_{k+1}, B''_ke_{k+1}^2, B''_ke_{k+2}, B''_ke_{k+2}^2, B''_ke_{k+1}e_{k+2},  B''_ke_{k+1}^2e_{k+2}^2)
$$
-->

---

## Property $(\beta)$ for $s=2$

$(\beta)$: stratifications on $s^2\times s \times s$, $s\times s^2 \times s$ and $s \times s \times s^2$ grids.

Thm: $D$ has property $\beta$ iff

1. $A$ is of resolution $IV$ or higher.
2. $(B, B') \subseteq \bar{A}$.
3. $(B, B')$ does not contain any interaction column involving two factors from $A$.

---

## Property $(\beta)$ for $s=2$

The thm is based on $(a_i, a_j, a_u, b_u)$ being $\text{OA}(n, 4, s, 4)$.

1. $(a_i, a_j, a_u)$ do not form a word of length 3: $A$ is resolution $IV$.
2. $(a_i, a_j, b_u)$ do not form a word of length 3: $B$ does not contain any 2fi from $A$.
3. $(a_i, a_u, b_u)$ do not form a word of length 3: $(B, B') \subseteq \bar{A} = S \setminus A$.
4. $(a_i, a_j, a_u, b_u)$ do not form a word of length 3: $B'$ does not contain any 2fi from $A$.

---

## Construction of $(\beta)$ for $s=2$

Let $P_0$ consists of $e_3, \dots, e_k$ and all their interactions.

Let $P = (I, P_0)$.

Then, we have $S = (P_0, e_1P, e_2P, e_1e_2P) \rightarrow A = e_1P$ and $B = e_2P.$

---

## For $s=3$

Let $P_0$ consists of $e_3, \dots, e_k$ and all their interactions.

Let $P = (I, P_0)$.

Then, we have

$S = (P, e_1P, e_1^2P, e_2P, e_2^2P, e_1e_2P, e_1^2e_2^2P, e_1e_2^2P, e_1^2e_2P)$

---

## After Meeting

1. The grouping for $(\alpha)$ should use the correct permutation.
2. Now `s22` passed but `s111` still need to figure out.
3. $(\beta)$ looks promising. Try verify it.
