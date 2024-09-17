---
marp: true
theme: gaia
paginate: true
color: black
backgroundImage: url('https://i.imgur.com/BgTCqJd.png')
style: |
  section {
    padding-top: 140px;
    padding-left: 200px;
    padding-right: 150px;
  }
  p {
    font-size: 24px;
    line-height: 1.5;
  } 
  li {
    font-size: 24px;
    line-height: 1.5;
  }
  h1 {
    font-size: 48px;
  }
  code {
    background-color: #dbdbdb;
    color: black;
  }
  table {
    font-size: 24px;
  }
  section.cover h1 {
    font-size: 70px;
  }
  section.cover p {
    padding-top: 5px;
    padding-bottom: 5px;
    line-height: 0.8;
  }
math: mathjax
---

<!-- _class: cover -->

<br>

# Weekly Meeting

Topic: Exhausive search for $9\times9$ ($m=11$)

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: Sept. 18, 2024

---

# Property for finding $9\times9$

If $D= (d_1, \dots, d_m)$ is constructed via $D = sA+B$ ,and $D$ is $\text{SOA}(2+)$.

For the case where $s=3$, these statements are equivalent, given $i \neq j$, $i<j$:

1. $(d_i, d_j)$ achieve stratification over $s^2\times s^2$ grids.
2. $(a_i, b_i, a_j, b_j)$ is $\text{OA}(n, 4, 3, 4)$.
3. $(b_i, b_j, a_ib_i, a_ib_i^2, a_jb_j, a_jb_j^2)$ are different factors from $S$.

---

# Why (3) ?

$\begin{aligned} 
a_i \times b_i \times b_j \neq I &\rightarrow a_i \times b_i \times b_j \neq I \rightarrow b_j \neq a_ib_i \\
&\rightarrow a_i \times b_i \times b_j^2  \neq I\rightarrow b_j^2 \neq a_ib_i \rightarrow b_j \neq a_ib_i\\
&\rightarrow a_i \times b_i^2 \times b_j \neq I\rightarrow b_j \neq a_i b_i^2 \\
&\rightarrow a_i \times b_i^2 \times b_j^2 \neq I\rightarrow b_j^2 \neq a_i b_i^2 \rightarrow b_j \neq a_i b_i^2
\end{aligned}$

$\begin{aligned} 
a_j \times b_i \times b_j \neq I &\rightarrow a_j \times b_i \times b_j \neq I \rightarrow b_i \neq a_jb_j \\
&\rightarrow a_j \times b_i \times b_j^2  \neq I\rightarrow b_i \neq a_jb_j^2 \\
&\rightarrow a_j \times b_i^2 \times b_j \neq I\rightarrow b_i^2 \neq a_j b_j \rightarrow b_i \neq a_jb_j\\
&\rightarrow a_j \times b_i^2 \times b_j^2 \neq I\rightarrow b_i^2 \neq a_j b_j^2  \rightarrow b_i \neq a_jb_j^2
\end{aligned}$

$\begin{aligned}
b_i \times b_j \neq I &\rightarrow b_i\times b_j \neq I \rightarrow b_i \neq b_j\\
&\rightarrow b_i \times b_j^2 \neq I \rightarrow b_i \neq b_j^2  = b_j
\end{aligned}$

---

# Why (3) ?

$a_i \times b_i \times a_j \times b_j \neq I$

$\begin{aligned} 
&\rightarrow a_i \times a_j \times b_i \times b_j \neq I \rightarrow a_ib_i \neq a_jb_j \\
&\rightarrow a_i \times a_j\times b_i \times b_j^2 \neq I \rightarrow a_ib_i \neq a_j b_j^2 \\
&\rightarrow a_i \times a_j\times b_i^2 \times b_j \neq I  \rightarrow a_ib_i^2 \neq a_j b_j \\
&\rightarrow a_i \times a_j\times b_i^2 \times b_j^2 \neq I \rightarrow a_ib_i^2 \neq a_j b_j^2 \\
&\rightarrow a_i \times a_j^2\times b_i \times b_j \neq I \rightarrow a_ib_i \neq a_j^2 b_j  \rightarrow a_i b_i \neq a_j b_j^2\\
&\rightarrow a_i\times a_j^2 \times b_i \times b_j^2 \neq I \rightarrow a_ib_i \neq a_j^2 b_j^2 \rightarrow a_i b_i \neq a_j b_j \\
&\rightarrow a_i \times a_j^2\times b_i^2 \times b_j \neq I \rightarrow a_ib_i^2 \neq a_j^2 b_j \rightarrow a_i b_i^2 \neq a_j b_j ^ 2\\
&\rightarrow a_i \times a_j^2\times b_i^2 \times b_j^2 \neq I \rightarrow a_ib_i^2 \neq a_j^2 b_j^2 \rightarrow a_i b_i ^ 2 \neq a_j b_j
\end{aligned}$
