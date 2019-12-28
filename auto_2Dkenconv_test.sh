#!/bin/bash
script_sT=$(date +%s)

touch ken2D_summary.txt # Create summary file
sed -i "s/NSW.*/NSW = 0/" INCAR # No ionic relaxation for convergence test
sed -i "s/IBRION.*/IBRION = -1/" INCAR # No ionic relaxation

for ((i = 3; i <= 8; i++)) # for loop from 1 to 8
do 

cat >KPOINTS<< !
Automatic mesh # First line is comment line in KPOINTS
0 # Number of k-points -> 0 means auto-generation scheme
Monkhorst # Use Monkhorst Pack scheme
$i $i $i
0 0 0
!

for a in `seq 200 50 800` # for loop for encut
do
vasponlyin # Clear output files
sT=$(date +%s) # Start time in seconds
sed -i "s/ENCUT.*/ENCUT = $a/" INCAR # Set ENCUT value

gerun vasp_std > vasp_output.$JOB_ID.$i.$a

head -n 3 OUTCAR | tail -1 >> ken2D_summary.txt
echo $i x $i x $i >> ken2D_summary.txt
echo "Plane Wave Energy Cutoff: $a eV" >> ken2D_summary.txt
tail -n 3 OSZICAR | grep -o "E0= -..............." >> ken2D_summary.txt
tail -n 2 OSZICAR | head -1 | cut -c1-8 >> ken2D_summary.txt
grep "free  energy   TOTEN" OUTCAR >> ken2D_summary.txt
grep -A 9 "General timing and accounting informations for this job" \
OUTCAR >> ken2D_summary.txt

totT=$(($(date +%s)-sT)) # Subtract start time from current time to get total time
echo "Total RUN time (sec):  $totT" >> ken2D_summary.txt
done
done

sed -i "s/NSW.*/NSW = 99/" INCAR
sed -i "s/8 8 8/5 5 5/" KPOINTS
sed -i "s/IBRION.*/IBRION = 2/" INCAR
sed -i "s/ENCUT.*/ENCUT = 520/" INCAR

script_totT=$(($(date +%s)-script_sT))
echo "Overall total RUN time of script (sec) = $script_totT" >> ken2D_summary.txt
grep 'TOTEN......................' ken2D_summary.txt | cut -c 33-44 >> kenconv_energy_list.txt
