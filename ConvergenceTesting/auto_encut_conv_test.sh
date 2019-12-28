#!/bin/bash

script_sT=$(date +%s)

touch encut_summary.txt
sed -i 's/IBRION.*/IBRION = -1/' INCAR # No ionic relaxation
sed -i 's/NSW.*/NSW = 0/' INCAR # No ionic relaxation

for a in `seq 200 20 700`
do
vasponlyin # Clear output files

sT=$(date +%s) # Start time in seconds

sed -i "s/ENCUT.*/ENCUT = $a/" INCAR
# No ionic relaxation, because we're just checking
# convergence of electronic relaxation steps 


gerun vasp_std > vasp_run.$JOB_ID.$a

head -n 3 OUTCAR | tail -1 >> encut_summary.txt
echo "Plane Wave Cutoff Energy: $a eV" >> encut_summary.txt
tail -n 3 OSZICAR | grep -o "E0= -..............." >> encut_summary.txt
tail -n 2 OSZICAR | head -1 | cut -c1-8 >> encut_summary.txt
grep "free  energy   TOTEN" OUTCAR >> encut_summary.txt
grep -A 9 "General timing and accounting informations for this job" \
OUTCAR >> encut_summary.txt


totT=$(($(date +%s)-sT)) # Subtract start time from current time to get total time
echo "Total RUN time (sec):  $totT" >> encut_summary.txt

done

sed -i 's/NSW.*/NSW = 99/' INCAR
sed -i 's/ENCUT.*/ENCUT = 520/' INCAR
sed -i 's/IBRION.*/IBRION = 2/' INCAR

script_totT=$(($(date +%s)-script_sT))
echo "Overall total RUN time of script (sec) = $script_totT" >> encut_summary.txt
grep 'TOTEN......................' encut_summary.txt | cut -c 33-44 >> econv_energy_list.txt

