import os
import sys

dis = sys.argv[1]
mat = sys.argv[2]

pairs = {}
fout = open(mat, 'w')


with open (dis) as f:
	for i in f:
		ii = i[:-1].split()
		#print (ii)
		a = ii[0]
		b = ii[1]
		c = float(ii[2])/int(ii[3])
		
		if a not in pairs:	
			pairs[a] = {}
		pairs[a][b] = c

		if b not in pairs:
			pairs[b] = {}
		pairs[b][a] = c

ll = []

for i in pairs:
	ll.append(i)
for i in pairs[ll[0]]:
	if i not in ll:
		ll.append(i)

#ll = os.popen("cut -f1,2 " + dis + " | xargs -n1|sort|uniq").read()[:-1].split("\n")
fout.write("\t" + str(len(ll)) + "\n")


#print (pairs)
for each in ll:
	fout.write(each)
	for tt in ll:
		if each == tt:
			fout.write("\t0.00000000")
		else:
			fout.write("\t" + str(pairs[each][tt]))
	fout.write("\n")
	
fout.close()

