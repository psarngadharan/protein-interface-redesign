#! /bin/bash
echo 6 | gmx pdb2gmx -f 6M0J_fixed.pdb -o name_processed.gro -water tip3p -ignh
gmx editconf -f name_processed.gro -o name_newbox.gro -c -d 1.0 -bt cubic
gmx solvate -cp name_newbox.gro -cs spc216.gro -o name_solv.gro -p topol.top
gmx grompp -f ions.mdp -c name_solv.gro -p topol.top -o ions.tpr
gmx genion -s ions.tpr -o name_solv_ions.gro -p topol.top -pname NA -nname CL -neutral
gmx grompp -f em.mdp -c name_solv_ions.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -deffnm nvt
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx mdrun -deffnm npt
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md.tpr
gmx mdrun -deffnm md
