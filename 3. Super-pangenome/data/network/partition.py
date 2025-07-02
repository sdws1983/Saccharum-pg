import os
import sys

total = int(sys.argv[1])
win = int(sys.argv[2])
output = sys.argv[3]

##produce a partition file 
l1=list(range(1,round(total/win)))
l2=list(range(1,total,win))
l3=list(range(win,total,win))
l4 = ["DNA, part" + str(a) + " = " + str(b) + "-" + str(c) for a,b,c in zip(l1,l2,l3)]
with open(output, 'w') as file:
    for item in l4:
        file.write(f"{item}\n")
