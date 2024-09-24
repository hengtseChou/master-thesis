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

Topic: Searching $s\times s\times s$ and $s^2\times s^2$ for $\text{SOA}(2+)$

<br>

Presenter: Heng-Tse Chou @ NTHU STAT

Date: Sept. 25, 2024

---

# This week

**Completed:**

- Greedy Algorithm
- 16 runs (Both $2\times 2\times 2$ and $2^2\times 2^2$)
- 32 runs ($2\times 2\times 2$)

**TODO:**

- Put results over Overleaf

---

# 16 runs, case I

Maximizing $2\times2\times2$, then $4\times4$.

![w:900](s16-case1.png)

---

# 16 runs, case II

Maximizing $4\times4$, then $2\times2\times2$.

![w:900](s16-case2.png)

---

# 32 runs

Exhaustive search for $2\times2\times2$ is instant.

![w:700](s32-1.png)

---

# 32 runs

![w:700](s32-2.png)
