import os
import sys

cl = sys.argv[1]
fdna = sys.argv[2]

dna = {}
with open(fdna) as f:
	for i in f:
		if i.startswith(">"):
			id = i[1:-1]
		else:
			dna[id] = i[:-1]

#print (dna)
	
ct = ""		
with open(cl) as f:
	for i in f:
		i = i[:-1].split("\t")	
		if i[0] != ct:
			print (">" + i[0])
			ct = i[0]
			print (">" + i[1])
			print (dna[i[1]])
		else:
			print (">" + i[1])
			print (dna[i[1]])
