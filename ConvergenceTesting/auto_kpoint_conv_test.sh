#!/bin/bash
script_sT=$(date +%s)

touch kpt_summary.txt # Create summary file
sed -i 's/NSW.*/NSW = 0/' INCAR # No ionic relaxation for convergence test
sed -i 's/IBRION.*/IBRION = -1/' INCAR # No ionic relaxation

for ((i = 1; i <= 8; i++)) # for loop from 1 to 8
do 
vasponlyin # Clear output files

sT=$(date +%s) # Start time in seconds

cat >KPOINTS<< !
Automatic mesh # First line is comment line in KPOINTS
0 # Number of k-points -> 0 means auto-generation scheme
Monkhorst # Use Monkhorst Pack scheme
$i $i $i
0 0 0
!

gerun vasp_std > vasp_output.$JOB_ID.$i

head -n 3 OUTCAR | tail -1 >> kpt_summary.txt
echo $i x $i x $i >> kpt_summary.txt
tail -n 3 OSZICAR | grep -o "E0= -..............." >> kpt_summary.txt
tail -n 2 OSZICAR | head -1 | cut -c1-8 >> kpt_summary.txt
grep "free  energy   TOTEN" OUTCAR >> kpt_summary.txt
grep -A 9 "General timing and accounting informations for this job" \
OUTCAR >> kpt_summary.txt

totT=$(($(date +%s)-sT)) # Subtract start time from current time to get total time
echo "Total RUN time (sec):  $totT" >> kpt_summary.txt

done

sed -i 's/NSW.*/NSW = 99/' INCAR
sed -i 's/8 8 8/5 5 5/' KPOINTS
sed -i 's/IBRION.*/IBRION = 2/' INCAR

script_totT=$(($(date +%s)-script_sT))
echo "Overall total RUN time of script (sec) = $script_totT" >> kpt_summary.txt
grep 'TOTEN......................' kpt_summary.txt | cut -c 33-44 >> kconv_energy_list.txt
