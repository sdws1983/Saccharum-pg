import os
import sys

vcf = sys.argv[1]


fo1 = open(vcf + ".out", "w")
#fo2 = open(vcf + "SV.out", "w")

fo1.write("Chr\tPos\tLongest\tLen\tAC\tAN\tNS\two\n")
with open(vcf) as f:
	for i in f:
		if i.startswith("#"):
			pass
		else:
			i = i[:-1].split("\t")
			chro = i[0]
			pos = i[1]
			ref = i[3]
			alt = i[4]
			info = i[7].split(";")
			
			for e in info:
				if e.startswith("AC"):
					ac = e
				if e.startswith("AN"):
					an = e
				if e.startswith("NS"):
					ns = e
			
			if len(alt.split(",")) > 1:
				alt = alt.split(",")
				tl = len(ref)
				longest = ref
				#dl = -len(longest)
				lt = []
				for t in alt:
					if len(t) > tl:
						longest = t
						tl = len(longest)
					lt.append(len(t) - len(ref))

				a1 = max(lt)
				a2 = min(lt)
				dl = a1 if abs(a1) >= abs(a2) else a2
						
					
				fo1.write(chro + "\t" + pos + "\t" + longest + "\t" + str(dl) + "\t" + ac.split("=")[1] + "\t" + an.split("=")[1] + "\t" + ns.split("=")[1] + "\tmulti-allelic\n")
				


			else:
				longest = ref if len(ref) >= len(alt) else alt
				dl = len(alt) - len(ref)
				
				
				
				
				
				fo1.write(chro + "\t" + pos + "\t" + longest + "\t" + str(dl) + "\t" + ac.split("=")[1] + "\t" + an.split("=")[1] + "\t" + ns.split("=")[1] + "\tbi-allelic\n")
				
fo1.close()	
			
			


