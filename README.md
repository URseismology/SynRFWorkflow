## Synthetic RF (Telewavesim) Workflow
*Evan Zhang
9/9/2021*
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
For this workflow to run, you will need to provide a text file containing the ray paramemters, edit the following scripts
`telewavesim_workflow.m`, `job_Telewavesim.sh`, `run_telewavesim.py`,
and run the main code
`telewavesim_workflow.m`.
This workflow should run on BlueHive.

 **1. Ray Parameter File**.  
 Prepare a text file contaning all the ray parameters you want to pass to the program, and save it to `rayp/`. An example is provided: `rayp/linspace.txt`.  
 
 **2. Edit Scripts**.  
	 **`telewavesim_workflow.m`**	  
	 Edits should only be made in the `Parameters Setup` section.  
	 `workDir`: change to your work directory, i.e., the location of this package;  
	 `modname`: the model name, which will be included in the name of the velocity model and the output MatLab structure;  
	 *model parameters (in each layer)*:  
	 `Dz`: thickness in km;  
	 `rho`: density in kg/m3;  
	 `Vp` and `Vs`: P and S velocity in km/s.  
	 `Vperc`, `Trend`, and `Plunge` are anisotropy parameters; leave them 0.0 for isotropic case.  
	 **`job_Telewavesim.sh`**  
	 `#SBATCH --mail-user="email_address"`: change to your email address;  
	 `python /directory/run_telewavesim.py $SLURM_ARRAY_TASK_ID`: change according to the directory where this package is located.  
	 **`run_telewavesim.py`**  
	 Go to the end of this script.  
	 `# specify slowness/rayp file`
         `ss=np.loadtxt('/directory/rayP/linspace.txt')`
	change to your ray parameter file;  
	`modname = 'sac/sim' # change here`
	normally no need to change; however, you may change it to the full directory for robustness.  

**3. Run the Main Code**.  
Run `telewavesim_workflow.m`, all at once, or section by section.  
After you finish, you should see MatLab structures saved in `matfile/` folder. The output structure contains the following fields: `rRF` (radial), `tRF` (transverse), `time`, `npts` (number of sample points), `srate` (sample rate), `bgntime`, `endtime`, `garc` (epicentral distance).
