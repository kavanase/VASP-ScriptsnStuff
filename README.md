# VASP-ScriptsnShit
Some VASP processing and convergence-testing shell scripts.

In [a relative link](ConvergenceTesting), there are shell scripts (plus job submission scripts for UCL HPC (SGE Batch Scheduler)) to run a VASP calculation with varying k-grid densities and/or varying plane wave energy cutoff (`ENCUT`). 
The final ground state energy for each calculation is then saved to an output text file, which can then be analysed by reading the file or graphically via the Jupyter notebook [a relative link](VASP Convergence Analysis.ipynb).
