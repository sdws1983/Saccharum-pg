import os
import sys

#js = sys.argv[1]
gf = sys.argv[1]
fo = sys.argv[2]
log = sys.argv[3]

fout = open(fo, 'w')
flog = open(log, 'w')

fout.write("id\tsimbub\tsupbub\tinsertion\tbubN50\n")
gfal = os.popen("ls " + gf).read()[:-1].split("\n")

def calculate_n_value(input_list, percentile):
    sorted_list = sorted(input_list, reverse=True)
    total = sum(sorted_list)
    target_total = total * percentile / 100

    cumulative_sum = 0
    n_value = None

    for value in sorted_list:
        cumulative_sum += value
        if cumulative_sum >= target_total:
            n_value = value
            break

    return n_value

for each in gfal:
	gfa = gf + "/" + each
	js = "test.json"
	out = os.popen("BubbleGun -g " + gfa + " bchains --bubble_json test.json --fasta test.fa && echo ok").read()[:-1].split("\n")
	for ee in out:
		print (ee)
		if "Simple" in ee:
			sib = int(ee.split(" ")[-1])
		elif "Super" in ee:
			spb = int(ee.split(" ")[-1])
		elif "insertions" in ee:
			inb = int(ee.split(" ")[-1])
	

#	spb = os.popen("cat " + js + " |jq '.[].bubbles' |fgrep \"super\"|wc -l").read()[:-1]
#	sib = os.popen("cat " + js + " |jq '.[].bubbles' |fgrep \"simple\"|wc -l").read()[:-1]
	print (spb)

	if spb == sib and spb == 0 and inb == 0:
		nnn = 0
	else:
		bub = os.popen("cat " + js + " |jq '.[].bubbles' |jq '.[].inside'|jq -c|sed 's/\"//g'|sed 's/\[//g'|sed 's/\]//g'").read()[:-1].split("\n")
		flog.write(gfa + "\t" + "|".join(bub) + "\n")

		seglist = {}
		pathlist = {} # node:path
		with open(gfa) as f:
			for i in f:
				if i.startswith("S"):
					ii = i[:-1].split("\t")
#					seglist[ii[1]] = int(ii[3].split(":")[2])
					seglist[ii[1]] = int(len(ii[2]))
				elif i.startswith("P"):
					ii = i[:-1].split("\t")
					pathseg = ii[2].split(",")
					#pathlist[ii[1]] = []
					for y in pathseg:
						y = y[:-1]
						if y in pathlist:
							pathlist[y].append(ii[1])
						else:
							pathlist[y] = [ii[1]]
#						pathlist[ii[1]].append(y)
			
#		print (pathlist)	
		bubl = []
#		pathlen = {}
		for i in bub:
			ii = i.split(",")
			m = 0
			pathlen = {}
			for t in ii:
				pi = pathlist[t] # node's paths
				for ip in pi:
					if ip not in pathlen:
						pathlen[ip] = seglist[t]
					else:
						pathlen[ip] += seglist[t]
			
			for ttt in pathlen:
				flog.write (gfa + "\t" + str(ttt) + "\t" + str(pathlen[ttt]) + "\t" + str(ii) + "\n")
				m = pathlen[ttt] if pathlen[ttt] > m else m
			bubl.append(int(m))
#		print (bubl)
		bubl.sort(reverse = True)
		#print (bubl)


		nnn = calculate_n_value(bubl, 50)

	print("N50 value:", nnn)
	fout.write(each + "\t" + str(sib) + "\t" + str(spb) + "\t" + str(inb) + "\t" + str(nnn) + "\n")

fout.close()
flog.close()
