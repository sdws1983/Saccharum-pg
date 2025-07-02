from Bio import AlignIO
import os
import sys

#js = sys.argv[1]
ms = sys.argv[1]
fo = sys.argv[2]



cutoff = 0.5


fout = open(fo, 'w')

fout.write("id\tlength\n")
msal = os.popen("ls " + ms).read()[:-1].split("\n")

for each in msal:
	i = ms + "/" + each
	msa = AlignIO.read(i, "fasta")

	# 初始化一个变量来存储没有gap的比对长度
	alignment_length_no_gaps = 0
	#print(msa)
	# 遍历每个列

	for column in range(msa.get_alignment_length()):
		# 统计当前列中没有gap的序列数
		no_gap_count = sum(1 for record in msa if record.seq[column] != "-")

		# 如果至少一半的序列没有gap，增加比对长度
		if no_gap_count >= (len(msa) * cutoff):
			alignment_length_no_gaps += 1
	
	fout.write(each + "\t" + str(alignment_length_no_gaps) + "\n")

fout.close()
