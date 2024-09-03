![Screenshot](PPGSynth.png)


PPGSynth Executable

1. Prerequisites for Deployment 

Verify that version 9.8 (R2020a) of the MATLAB Runtime is installed.   
If not, you can run the MATLAB Runtime installer.
To find its location, enter
  
    >>mcrinstaller
      
at the MATLAB prompt.
NOTE: You will need administrator rights to run the MATLAB Runtime installer. 

Alternatively, download and install the Windows version of the MATLAB Runtime for R2020a 
from the following link on the MathWorks website:

    https://www.mathworks.com/products/compiler/mcr/index.html
   
For more information about the MATLAB Runtime and the MATLAB Runtime installer, see 
"Distribute Applications" in the MATLAB Compiler documentation  
in the MathWorks Documentation Center.

2. Files to Deploy and Package

Files to Package for Standalone 
================================
-PPGSynth.exe
-MCRInstaller.exe 
    Note: if end users are unable to download the MATLAB Runtime using the
    instructions in the previous section, include it when building your 
    component by clicking the "Runtime included in package" link in the
    Deployment Tool.
-This readme file 



3. Definitions

For information on deployment terminology, go to
https://www.mathworks.com/help and select MATLAB Compiler >
Getting Started > About Application Deployment >
Deployment Product Terms in the MathWorks Documentation
Center.

Dynamic Modeling of PPG Signals
Previous studies have attempted to model PPG (Photoplethysmography) pulses using various approaches:

McSharry et al. introduced a dynamical model for generating synthetic ECG signals, which laid the groundwork for modeling biological signals like PPG. Their work has influenced subsequent research in synthetic biomedical signal generation [McSharry et al., 2003].
Shariati and Zahedi compared four linear parametric models for analyzing PPG signals, highlighting the strengths and limitations of each approach [Shariati & Zahedi, 2005].
Wang et al. utilized multi-Gaussian functions to fit single PPG waveforms, exploring the effects of different numbers of Gaussian functions on the simulation [Wang et al., 2013].
Liu et al. modeled carotid and radial artery pulse pressure waveforms using Gaussian curve fitting, providing insights into cardiovascular health through waveform analysis [Liu et al., 2013].
Martin-Martinez et al. proposed stochastic modeling to synthesize PPG signals. Their approach involved a single-pulse model based on two Gaussian functions with 10 parameters, using autoregressive moving average models to approximate these parameters [Martin-Martinez et al., 2013].
Couceiro et al. assessed cardiovascular function from multi-Gaussian fitting of a finger photoplethysmogram, demonstrating the application of Gaussian models in analyzing cardiovascular health [Couceiro et al., 2015].
Solosenko et al. developed a model for simulating PPG during atrial fibrillation, using a combination of log-normal and Gaussian waveforms. Their model required an ECG signal as an input parameter to connect individual PPG pulses according to RR intervals [Solosenko et al., 2017].
Tang et al. introduced a method for generating synthetic PPG signals using two Gaussian functions, further refining the modeling process [Tang et al., 2020].
Our Contribution
Unlike previous models that either focus on individual pulses or require additional inputs such as ECG signals, our dynamic model generates synthetic PPGs of varying lengths and sampling frequencies independently. This makes it a versatile tool for various applications in PPG signal analysis.

References
McSharry, P. E., Clifford, G. D., Tarassenko, L. & Smith, L. A. A dynamical model for generating synthetic electrocardiogram signals. IEEE Trans. Biomed. Eng. 50, 289–294 (2003).
Shariati, N. H. & Zahedi, E. Comparison of selected parametric models for analysis of the photoplethysmographic signal. In The International Conference on Computers, Communications, and Signal Processing with Special Track on Biomedical Engineering, 169–172 (2005).
Wang, L., Xu, L., Feng, S., Meng, M. Q. & Wang, K. Multi-Gaussian fitting for pulse waveform using weighted least squares and multi-criteria decision making method. Comput. Biol. Med. 43, 1661–1672 (2013).
Liu, C., et al. Modeling carotid and radial artery pulse pressure waveforms by curve fitting with Gaussian functions. Biomed. Signal Process. Control 8, 449–454 (2013).
Martin-Martinez, D., Casaseca-de-la-Higuera, P., Martin-Fernandez, M. & Alberola-Lopez, C. Stochastic modeling of the PPG signal: a synthesis-by-analysis approach with applications. IEEE Trans. Biomed. Eng. 60, 2432–2441 (2013).
Couceiro, R., et al. Assessment of cardiovascular function from multi-Gaussian fitting of a finger photoplethysmogram. Physiological Measurement 36.9, 1801 (2015).
Solosenko, A., Petrenas, A., Marozas, V. & Sornmo, L. Modeling of the photoplethysmogram during atrial fibrillation. Comput. Biol. Med. 81, 130–138 (2017).
Tang, Q., Chen, Z., Ward, R. et al. Synthetic photoplethysmogram generation using two Gaussian functions. Sci Rep 10, 13883 (2020). https://doi.org/10.1038/s41598-020-69076-x.
