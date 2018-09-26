# Readme

## Onset detection
Onset detection is already well-established research area in MIR and there are multiple efficient solutions for extraction onsets from various types of musical materials. Here we wanted to rely on a conventional technique that would be applied to as many different kinds of onsets in this particular corpora in order to make the temporal comparison of different instruments reliable.

## Goals and audio materials  
- to facilitate entrainment analyses in the [IEMP project](https://www.dur.ac.uk/iemp/), onsets need to extracted reliably, and transparently using the same technique from multiple instruments and performances.
- the temporal resolution of the onset estimation should high, much higher than the often used tolerance in onset detection evaluation (80 ms).
- Musical material in the project ranges from jembe music of West Africa to North Indian classical music to Western jazz.
- the IEMP Collection can be found at [OSF](https://osf.io/ks325/)

## Onset extraction 

Onsets were extracted based on envelope characteristics using MIR Toolbox ([Lartillot, Toiviainen, & Eerola, 2008](https://www.jyu.fi/hytk/fi/laitokset/mutku/en/research/materials/mirtoolbox)).

1. First the audio signal is band-pass filtered to eliminate frequencies above _900-1200 Hz_ (or any specific threshold) to focus on body resonances of the plucked instruments. 

2. The envelope of the filtered signal is then extracted and subjected to low-pass filtering and half-wave rectification before applying peak-picking. 

3.  Peak-picking algorithm had three parameters to determine (1) the local contrast threshold value, (2) normalised amplitude threshold value, and (3) threshold value for the minimum difference between peak values. 

4.  The optimal values of these parameters were defined for each instrument using a 1-minute sample of manually annotated onsets against 

## Code
`code` folder contains the following files:

* `contents.m` is script which allows to replicate the onset extraction accuracy analyses (F-measure) for a handful of files (sarod, sitar, guitar) which contained manully annotated ground-truth data (onsets). The output is written to `Accuracy.csv`.

`extract_onset_custom.m` if the function that carried out the extraction and takes in four possible parameters.

