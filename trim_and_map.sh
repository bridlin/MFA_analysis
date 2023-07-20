#!/bin/bash
#
#SBATCH -o slurm.%N.%j.out
#SBATCH -e slurm.%N.%j.err
#SBATCH --mail-type END
#SBATCH --mail-user b-barckmann@chu-montpellier.fr
#
#
#SBATCH --partition fast
#SBATCH --cpus-per-task 6
#SBATCH --mem 64GB



module load fastqc/0.11.9
module load bowtie2/2.4.1
module load samtools/1.13
module load trim-galore/0.6.5


source scripts/MFA_analysis/config.txt

mkdir $output_dir
for x in "${input_list[@]}"; do
# trim_galore --paired --output_dir $input_dir/ $input_dir/$x\_1.fastq.gz  $input_dir/$x\_2.fastq.gz && 
# fastqc $input_dir/$x\_1_val_1.fq.gz
# fastqc $input_dir/$x\_2_val_2.fq.gz
bowtie2 --very-sensitive-local --threads 6 -x $genome -1 $input_dir/$x\_1_val_1.fq.gz -2 $input_dir/$x\_2_val_2.fq.gz   -S $output_dir/$x\_$prefix\.sam &&
samtools view  -b -q 20 $output_dir/$x\_$prefix\.sam > $output_dir/$x\_$prefix\_filtered.bam &&
samtools sort $output_dir/$x\_$prefix\_filtered.bam -o $output_dir/$x\_$prefix\_filtered_sorted.bam &&
rm -f  $output_dir/$x\_$prefix\.sam &&
rm -f  $output_dir/$x\_$prefix\_filtered.bam  ; done