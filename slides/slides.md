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

Topic: fix `s111` stratification for property $\alpha$ with $k=6$; find property $\beta$

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: May 29, 2024

---

### Issues

1. `s111` stratification for property $\alpha$ with $k=6$
2. Construct property $\beta$

---

### Breaking down property $\beta$

$(a_i, a_j, a_u, b_u)$ being $\text{OA}$ with strength 4 implies

1. $a_ia_ja_u \neq I \rightarrow A$ is resolution $IV$.
2. $a_ia_jb_u \neq I \rightarrow B$ contains no 2fi from $A$.
3. $a_ia_ub_u \neq I \rightarrow (B', B'') \subseteq \bar{A}$
4. $a_ia_ja_ub_u \neq I \rightarrow$ $B'$ and $B''$ contains no 2fi from A.

---

### Breaking down property $\beta$

Therefore, $\text{SOA}(n, m, 27, 3)$ has property $\beta$ iff:

1. $A$ is resolution $IV$.
2. $(B, B', B'') \subseteq \bar{A}$.
3. $(B, B', B'')$ contains no 2fi from $A$.

---

### Construction for property $\beta$

Take $k=4$ for example.

$P_0 = (e_3, e_4, e_3e_4, e_3e_4^2)$
$P = (I, P_0, P_0^2)$

$A = e_1P$
$B = e_2P$
$B' = e_1e_2P$
$B'' = e_1e_2^2P \rightarrow S=(P_0, A, B, B', B'')$

---

### Construction for property $\beta$

This construction passed `s11` and `s21` but not passing `s111` and `s211`.

Reason: Duplicated $P_0$ in $A$.

This is similar to why our construction for property $\alpha$ with $k=6$ is not passign `s111`.

---

### Setup for property $\alpha$ with $k=6$

$A_6 = (A_4, e_5A_4, e_5^2A_4, e_6A_4, e_6^2A_4, e_5e_6A_4, e_5^2e_6^2A_4, e_5e_6^2A_4, e_5^2e_6A_4)$

Possible workaround: similar to how we construct grouping with $k=4$.

$\rightarrow$ Divide into 2 groups that any 2 columns from group 1 won't form $I$ with any 1 column from group 2.

---

### Grouping with $k=4$

| $\alpha$  |  $\beta$  | $\alpha\cdot\beta$ | $\alpha\cdot\beta^2$ |
| :-------: | :-------: | :----------------: | :------------------: |
|   $14$    |   $23$    |       $1234$       |      $12^23^24$      |
|  $1^24$   |  $2^23$   |     $1^22^234$     |      $1^223^24$      |
|   $24$    |  $1^23$   |      $1^2234$      |       $123^24$       |
|  $2^24$   |   $13$    |      $12^234$      |     $1^22^23^24$     |
|   $123$   |  $12^24$  |      $1^234$       |      $2^234^2$       |
| $1^22^23$ |  $1^224$  |       $134$        |       $234^2$        |
|  $12^23$  | $1^22^24$ |       $234$        |      $1^234^2$       |
|  $1^223$  |   $124$   |      $2^234$       |       $134^2$        |

---

### Grouping with $k=6$

<!-- |    $\alpha$     |     $\beta$     | $\alpha\cdot\beta$ | $\alpha\cdot\beta^2$ |
| :-------------: | :-------------: | :----------------: | :------------------: |
|   $5\cdot ?$    |   $6\cdot ?$    |    $56\cdot ?$     |    $56^2\cdot ?$     |
|  $5^2\cdot ?$   |  $6^2\cdot ?$   |  $5^26^2\cdot ?$   |    $5^26\cdot ?$     |
|   $6\cdot ?$    |  $5^2\cdot ?$   |   $5^26\cdot ?$    |     $56\cdot ?$      |
|  $6^2\cdot ?$   |   $5\cdot ?$    |   $56^2\cdot ?$    |   $5^26^2\cdot ?$    |
|   $56\cdot ?$   |  $56^2\cdot ?$  |    $5^2\cdot ?$    |     $6^2\cdot ?$     |
| $5^26^2\cdot ?$ |  $5^62\cdot ?$  |     $5\cdot ?$     |      $6\cdot ?$      |
|  $56^2\cdot ?$  | $5^26^2\cdot ?$ |     $6\cdot ?$     |     $5^2\cdot ?$     |
|  $5^26\cdot ?$  |   $56\cdot ?$   |    $6^2\cdot ?$    |      $5\cdot ?$      | -->

|                      |               |               |               |                 |               |                 |                 |               |
| :------------------: | :-----------: | :-----------: | :-----------: | :-------------: | :-----------: | :-------------: | :-------------: | :-----------: |
|       $\alpha$       |  $5\cdot ?$   | $5^2\cdot ?$  |  $6\cdot ?$   |  $6^2\cdot ?$   |  $56\cdot ?$  | $5^26^2\cdot ?$ |  $56^2\cdot ?$  | $5^26\cdot ?$ |
|       $\beta$        |  $6\cdot ?$   | $6^2\cdot ?$  | $5^2\cdot ?$  |   $5\cdot ?$    | $56^2\cdot ?$ |  $5^62\cdot ?$  | $5^26^2\cdot ?$ |  $56\cdot ?$  |
|  $\alpha\cdot\beta$  |  $56\cdot ?$  | $5^26\cdot ?$ | $5^26\cdot ?$ |  $56^2\cdot ?$  | $5^2\cdot ?$  |   $5\cdot ?$    |   $6\cdot ?$    | $6^2\cdot ?$  |
| $\alpha\cdot\beta^2$ | $56^2\cdot ?$ | $5^26\cdot ?$ |  $56\cdot ?$  | $5^26^2\cdot ?$ | $6^2\cdot ?$  |   $6\cdot ?$    |  $5^2\cdot ?$   |  $5\cdot ?$   |

Building blocks: $A_4, A_4^*, B_4, B_4^*$

$A_4B_4 = B'$
$A_4B_4^* = A_4B_4^2 = B''$
$A_4^*B_4 = A_4^2B_4 = A_4B_4^2 = B''$
$A_4^*B_4^* = A_4^2B_4^2 = A_4B_4 = B'$
