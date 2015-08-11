#!/bin/bash 

make clean
make all

#----------------start----------------------------#

nsamp=200


#CONVERT TO FASTA FORMAT

bedtools getfasta -fi hg19.fa -bed train.bed -fo train.fa
sed 's/>.*/&|1/' train.fa>train.fasta

bedtools getfasta -fi hg19.fa -bed test.bed -fo test.fa
sed 's/>.*/&|1/' test.fa>test.fasta


#CONVERT TO DICTIONARY

echo "Train:"train.fasta

echo "Test:"test.fasta

echo "Reading Input"
		

./readInput train.fasta lab.txt TRAIN.SEQ.txt

./readInput test.fasta lab.txt TEST.SEQ.txt

#GET LABELS

cat train.bed|awk '{print $4}'>TRAIN.LABELS.txt
cat test.bed|awk '{print $4}'>TEST.LABELS.txt

#CONCAT SEQUENCES TO FEED INTO GAPPED KERNEL

cat TRAIN.SEQ.txt TEST.SEQ.txt > INPUT.SEQ.txt

#RUN GAPPED KERNEL

./gappedKernel_v2 INPUT.SEQ.txt 9 6 5 KERNEL.txt
	
#PREPARE TRAIN (tr*tr)  AND TEST KERNELS (ts*tr)

cat KERNEL.txt|cut -d' ' -f1-$nsamp|head -$nsamp >TRAIN.KERNEL.txt

cat KERNEL.txt|cut -d' ' -f1-$nsamp|tail -$nsamp >TEST.KERNEL.txt


#ADD LABELS TO TRAIN AND TEST FILES

paste -d" " TRAIN.LABELS.txt TRAIN.KERNEL.txt>TRAIN.features.txt

paste -d" " TEST.LABELS.txt TEST.KERNEL.txt>TEST.features.txt

#TRAIN SVM MODEL 

./svm_learn TRAIN.features.txt model.tmp

./svm_classify -f 1 TEST.features.txt model.tmp PRED.txt

#GENERATE O/P FILE
	   
cat test.bed|awk '{print $1":"$2"-"$3}'|paste -d"\t" - PRED.txt> OUTPUT.txt
	
   
#-------end------------#
