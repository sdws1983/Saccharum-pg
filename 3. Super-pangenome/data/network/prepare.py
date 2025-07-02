from Bio import Phylo
import re
import sys


# some samples will be removed from tree.
#prune_list = ['bracteata_1','bracteata_E1','bracteata_E2','viridis_3','vesca_3','bracteata_3','mandschurica_1','mandschurica_2','mandschurica_3']
# Function to convert tree file to NEXUS format and remove TaxLabels
def convert_to_nexus(input_file, output_file):
    # Read the trees from the input file
    trees = list(Phylo.parse(input_file, 'newick'))
    
    # Write the trees to a temporary NEXUS file
    temp_output_file = 'temp_output_file.nex'
    Phylo.write(trees, temp_output_file, 'nexus')
    
    # Read the temporary NEXUS file
    with open(temp_output_file, 'r') as file:
        nexus_content = file.read()
    
    # Remove the TaxLabels block using regex
    nexus_content = re.sub(r'Begin Taxa;.*?End;', '', nexus_content, flags=re.DOTALL)
    
    # Write the modified content to the final output file
    with open(output_file, 'w') as file:
        file.write(nexus_content)

# Example usage
input_file = sys.argv[1]#'./Genetree/loci.treefile'  # replace with your input file name
output_file = sys.argv[2]#'./PhyloNet/locitree_noMan.nex'  # replace with your desired output file name
convert_to_nexus(input_file, output_file)
phy_script = """
BEGIN PHYLONET;
InferNetwork_MPL (all) 1 -pl 48 -x 100 -n 5 -h {nR570,ROC22,ZZ} -di -a <nR570:nR570_A,nR570_B,nR570_C,nR570_D,nR570_E,nR570_F,nR570_G;ZG:ZG_A,ZG_B,ZG_C,ZG_D,ZG_E,ZG_F,ZG_G,ZG_H;NpX:NpX_A,NpX_B,NpX_C,NpX_D;ROC22:ROC22_A,ROC22_B,ROC22_C,ROC22_D,ROC22_E,ROC22_F,ROC22_G,ROC22_H,ROC22_I,ROC22_J,ROC22_K,ROC22_L;Srufi:Srufi;ZZ:ZZ_A,ZZ_B,ZZ_C,ZZ_D,ZZ_E,ZZ_F,ZZ_G,ZZ_H,ZZ_I,ZZ_J,ZZ_K,ZZ_L;Srufi2:Srufi2;LAp:LAp_A,LAp_B,LAp_C,LAp_D,LAp_E,LAp_F,LAp_G,LAp_H;AP85re:AP85re_A,AP85re_B,AP85re_C,AP85re_D> ;
END;
"""
with open(output_file, 'a') as file1:
    # Writing data to a file
    file1.write(phy_script)
