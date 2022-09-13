# abc-vocoder
A vocoder to simulate a loss of (A)udibility, (B)roadness 
of tuning, and (C)ompression (i.e., reduced dynamic range) 

This is a 29 channel vocoder, with each bandpass filter 
spaced in equivalent rectangular bandwidth (ERB) steps. Tonal 
carriers with a frequency equivalent to the center frequency 
of each bandpass filter in the filterbank are used. If you 
would like some background on how vocoders work, see 
[Loizou (2006)](https://ecs.utdallas.edu/loizou/cimplants/chap_loizou_review2006.pdf).
This vocoder was developed for a collaboration with Dr. 
Kristin Uhler.

There is a sample file (Glow.wav) for convenience. The output 
is RMS normalized to the input file. To get started: 
1. Open ABCVocoder.m
2. Click "Run" in MATLAB
3. Follow the instructions in the program (upload files, change parameters, vocode!)
