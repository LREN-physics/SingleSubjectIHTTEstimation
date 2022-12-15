# Subject Specific IHTT Estimation
Estimation of Interhemispheric Transfer Time (IHTT) from EEG data for each subject individually.

## Introduction:

This repository is related to the scientific article:
Single-subject EEG measurement of  interhemispheric transfer time for the in-vivo estimation of axonal morphology  
Rita Oliveira, Marzia De Lucia, Antoine Lutti

In our previous work, we used data collected in-vivo in humans to estimate microscopic morphologic features of the white matter tracts:  
*Oliveira, R., Pelentritou, A., Di Domenicantonio, G., De Lucia, M., and Lutti, A. (2022). In vivo Estimation of Axonal Morphology From Magnetic Resonance Imaging and Electroencephalography Data. Front. Neurosci. 16, 1–18. doi: 10.3389/fnins.2022.874023.*  
The analysis code to estimate the interhemispheric transfer time (IHTT) for a group of participants and the axonal radius distribution, P(r) and the g-ratio dependence on the radius, g(r) can be found here: 
https://github.com/rita-o/AxonalMorphology

In the current repository, we focus on extending the previous approach to estimate IHTT for each subject individually. We calculate IHTT in 3 ways:  
   (I) on the original CD data  
   (II) on the CDs masked with the significant clusters obtained with cluster permutation   
   (III) on the time course of the number of vertices of the significant clusters obtained with cluster permutation   

## Authors:

Author: Rita Oliveira, PhD student  
PIs: Marzia De Lucia, Antoine Lutti  

Laboratory for Research in Neuroimaging (LREN)  
Department of Clinical Neuroscience, Lausanne University Hospital and University of Lausanne  
Mont-Paisible 16, CH-1011 Lausanne, Switzerland  

Email: rita.oliveira.uni@gmail.com

Last updated: December 2022

## Content:

This repository includes the analysis codes for IHTT estimation at the single subject level.

The codes for preprocessing of EEG data (including the statistical analysis with cluster permutation) and for estimating in-vivo microstructural features of white matter tracts are complementary and can be found here: https://github.com/rita-o/AxonalMorphology

## Requirements:

A running version of Matlab (https://ch.mathworks.com/products/matlab.html) and fieldtrip-20191206 (https://www.fieldtriptoolbox.org/download/) (not provided here) are necessary to run this analysis.  
The Signal Processing toolbox from Matlab is also necessary to use the function *findpeaks*.


## Input data:

The data necessary to run this analysis can be found in an online repository and is composed of:

- Stats_Source_CondNameVF_Occipital_LeftBrainOccipital.mat - Result of the cluster permutation for the left brain cortex for the CondNameVF, CondName being Left or Right visual stimulation (Fieldtrip stat structure)  
- Stats_Source_CondNameVF_Occipital_RightBrainOccipital.mat - Result of the cluster permutation for the right brain cortex for the CondNameVF, CondName being Left or -  Right visual stimulation (Fieldtrip stat structure)  
- CD_CondNameVisualField_LeftBrainOccipital.mat - Current source densities (pA.m) of each brain vertice, trial, and time point for the left brain occipital cortex [#trials x #vertices x #timepoints]  
- CD_CondNameVisualField_RightBrainOccipital.mat - Current source densities (pA.m) of each brain vertice, trial, and time point for the right brain occipital cortex [#trials x #vertices x #timepoints]  
- time_vec.mat - Time vector associated with the timecourses [1 x #timepoints]  
- Occipital_vertices.mat - Structure containing the vertices of the brain mesh of the region of interest. Occipital_vertices.Vertices [1 x #vertices]  

## Output data:
Structure containing IHTT estimated in the 3 ways described above and corresponding latencies of maximal activity in each hemisphere.

## How to use:

- Download the provided repository.
- In Matlab, add to the paths your Fieldtrip installation folder and the folder that contains the provided repository.
- Edit GetParams.m according to your working directories.
- Run the main function Main().
