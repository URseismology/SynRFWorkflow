## Synthetic RF (Telewavesim) Workflow
*Evan Zhang
10/6/2021*
### Overview
This workflow reads in the ***velocity structures*** and ***ray parameters***, and outputs the synthetic receiver function (RF) traces. The synthetic RFs are calculated using Telewavesim (Audet, 2016).

### Contents
 - The workflow includes the following ***scripts***:  
`telewavesim_workflow.m`: the main code;  
`get_rayP.m`: calculate ray parameters from real seismic data;  
`genRFsyn.m`: read in the velocity structure and store in MatLab variable;  
`matmod2txt_noprem.m`: write velocity structure to text file;  
`sac2strucwrap.m`: read in the output sac files from telewavesim and save them into MatLab structures;  
`raypToEpiDist.m`: convert ray parameters to epicentral distances (or the other way around);  
`job_Telewavesim.sh`: bash script to run Telewavesim program on BlueHive;  
`run_telewavesim.py`: python script of Telewavesim program.  
- There are four (4) ***folders*** in the package:  
`model/`: velocity model files generated in the workflow;  
`rayP/`: ray parameter files you provide;  
`sac/`: sac files of RF traces generated from Telewavesim;  
`matfile/`: final output of MatLab structures.  

### Usage
For this workflow to run, you will need to provide a text file containing the ray paramemters, edit and run the main code
`telewavesim_workflow.m`.

This workflow should run on BlueHive.

 **1. Ray Parameter File**.  
 Prepare a text file contaning all the ray parameters you want to pass to the program, and save it to `rayp/`. An example is provided: `rayp/linspace.txt`.  
 
 **2. Edit Scripts**.  
	 **`telewavesim_workflow.m`**	  
	 Edits should only be made in the `Parameters Setup` section.  
	 `workDir`: change to your work directory, i.e., the location of this package;  
	 `modname`: the model name, which will be included in the name of the velocity model and the output MatLab structure;  
	   \
	 *model parameters (in each layer)*:  
	 `Dz`: thickness in km;  
	 `rho`: density in kg/m3;  
	 `Vp` and `Vs`: P and S velocity in km/s.  
	 `Vperc`, `Trend`, and `Plunge` are anisotropy parameters; leave them 0.0 for isotropic case.   
	 *other options*:
	 `DelSac`: 0 if you wish to keep the sac files, 1 if you wish to delete them.
	 `npts`, `loco` and `hico`: sample points, lower and higher corner frequency of synthetic RFs.
	 
**3. Run the Main Code**.  
Run `telewavesim_workflow.m`, all at once, or section by section.  
After you finish, you should see MatLab structures saved in `matfile/` folder. The output structure contains the following fields: `rRF` (radial), `tRF` (transverse), `time`, `npts` (number of sample points), `srate` (sample rate), `bgntime`, `endtime`, `garc` (epicentral distance).
You will also see a plot showing all the synthetic RF traces against epicentral distance, with predicted arrival times for Ps conversions and their multiples.
