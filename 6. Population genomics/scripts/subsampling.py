import sys
import os
import numpy as np

np.random.seed(0)

vcf = sys.argv[1]
out = sys.argv[2]

fout = open(out, 'w')

import gzip

with gzip.open(vcf, 'rt') as f:
#with open(vcf) as f:
	for i in f:
		if i.startswith("#"):
			fout.write (i)
		else:
			ii = i[:-1].split("\t")
			out = "\t".join(ii[:68])
			for t in range(68, len(ii)):
				if ii[t].startswith("./."):
					out += ("\t" + ii[t])
				else:
					float_list = [float(x) for x in ii[t].split(":")[2].split(",")]
					result_list = [x / sum(float_list) for x in float_list]
					p = np.array(result_list)
					index = np.random.choice([0, 1], size=2, p = p.ravel())
					index = [str(x) for x in index]
					#print ("/".join(sorted(list(index))) )
					out += ("\t" + "/".join(sorted(list(index))) + ":" + ":".join(ii[t].split(":")[1:]))
			fout.write (out + "\n")


fout.close()
			
				
