# Mermaid graphs using the DiagrammeR package
# Diagrammer: https://github.com/rich-iannone/DiagrammeR
# mermaid flowcharts: http://knsv.github.io/mermaid/flowchart.html
# graphViz: http://www.graphviz.org/Documentation.php

library(DiagrammeR)

# A Causal Diagram for cow fertility problems, based on Example 1.4 of "Veterinary Epidemiologic Reasearch" by Dohoo et al.

mermaid("
        graph LR
        A(Age)-->F(Fertility)
        A-->O(Cistic ovarian <br> disease)
        A-->R(Retained <br> placenta)
        R-->O
        R-->M(Metritis)
        M-->O
        O-->F
        M-->F

        style A fill:#FFFFFF, stroke-width:0px
        style R fill:#FFFFFF, stroke-width:0px
        style M fill:#FFFFFF, stroke-width:0px
        style O fill:#FFFFFF, stroke-width:0px
        style F fill:#FFFFFF, stroke-width:0px
        ")

# The same can be achieved with the flexible and nicer but more complicated grViz

grViz("
digraph causal {

  # Nodes
  node [shape = plaintext]
  A [label = 'Age']
  R [label = 'Retained\n Placenta']
  M [label = 'Metritis']
  O [label = 'Cistic ovarian\n disease']
  F [label = 'Fertility']
  
  # Edges
  edge [color = black,
        arrowhead = vee]
  rankdir = LR
  A->F
  A->O
  A->R
  R->O
  R->M
  M->O
  O->F
  M->F
  
  # Graph
  graph [overlap = true, fontsize = 10]
}")