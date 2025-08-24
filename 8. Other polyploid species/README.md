### 01. Cotton


### 02. Potato


### 03. Wheat

cut -f 3 pggb.histgrowth.node.tsv | sed -n '7,$p' > growth.list
python ~/pangenome_curve.py  growth.list  > growth.list.stats
