import os
import sys
from collections import Counter
from collections import Counter

def zero_prop_exclude_dots(lst):
    """
    计算 lst 中 '0' 在所有非 '.' 元素中的占比（返回小数）
    如果非 '.' 元素为 0，则返回 0
    """
    cnt = Counter(lst)
    zero_count = cnt.get('0', 0)
    non_dot_count = sum(v for k, v in cnt.items() if k != '.')
    return zero_count / non_dot_count if non_dot_count else 0


vcf = sys.argv[1]
so = sys.argv[2].split(",")
ss = sys.argv[3].split(",")
out = sys.argv[4]

fout = open(out, 'w')

cutoff = 0.7
exclude_conflict = True

so_pos = []
ss_pos = []
with open(vcf) as f:
	for i in f:
		if i.startswith("#"):
			if i.startswith("#CHRO"):
				ii = i[:-1].split("\t")
				for j in range(9,len(ii)):
					for k in so:
						if k in ii[j]:
							so_pos.append(j)
					for k in ss:
						if k in ii[j]:
							ss_pos.append(j)
			else:
				pass
		else:
			ii = i[:-1].split("\t")
			chro = ii[0]
			pos = ii[1]
			ref = ii[3]
			alt = ii[4]		

			info = ii[7]
			conflict_stat = "F"

			if exclude_conflict:
				if "CONFLICT" in info:
					conflict = info.split("CONFLICT=")[1].split(";")[0].split(",")
					for t1 in (ss + so):
						for t2 in conflict:
							if t1 in t2:
								conflict_stat = "T"
	
			so_geno = []
			ss_geno = []

			for j in range(9,len(ii)):
				if j in so_pos:
					so_geno.append(ii[j])
				elif j in ss_pos:
					ss_geno.append(ii[j])


			
			so_prop = zero_prop_exclude_dots(so_geno)
			ss_prop = zero_prop_exclude_dots(ss_geno)
			so_missing = so_geno.count('.')/len(so_geno)
			ss_missing = ss_geno.count('.')/len(ss_geno)

			if so_prop >= cutoff and ss_prop <= (1 - cutoff): #and so_missing <= 0.5 and ss_missing <= 0.5:
				fout.write("\t".join([chro,pos,ref,alt,str(so_prop),str(ss_prop),str(so_missing),str(ss_missing),"SO",conflict_stat]) + "\n")
			elif ss_prop >= cutoff and so_prop <= (1 - cutoff): #and so_missing <= 0.5 and ss_missing <= 0.5:
				fout.write("\t".join([chro,pos,ref,alt,str(so_prop),str(ss_prop),str(so_missing),str(ss_missing),"SS",conflict_stat]) + "\n")
				

fout.close()

