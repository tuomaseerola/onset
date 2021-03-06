# Onset detection in the Interpersonal Entrainment in Musical Performance

Onset detection is a well-established research area in MIR and there are multiple efficient solutions for extraction onsets from various types of musical materials. In the context of [Interpersonal Entrainment in Musical Performance (IEMP)](https://www.dur.ac.uk/iemp/), AHRC-funded research project, we wanted explore how tightly or loosely musicians in different ensembles synchronise to each other. For this, we needed to extract onsets from diverse range of multitrack audio recordings. We wanted to rely on a conventional onset extraction technique that would be applied to as many different kinds of onsets in order to make the temporal comparison of different instruments comparable. Also, we wanted to keep the temporal resolution of the onset estimation high, much higher than the often used tolerance in the onset detection evaluation (e.g., 80 ms).

A number of other onset detection techniques (e.g, spectral difference, phase deviation, etc.) could have been used. There some widely available tools (e.g., _Sonic Visualiser_) for onset extraction, but we were not satisfied with accuracy and options this tool provided for our project. 

## Audio materials
- Musical material in the [IEMP](https://www.dur.ac.uk/iemp/) project ranges from jembe music of West Africa to North Indian classical music to Western jazz.
- IEMP Collection with annotations, audio and videos can be found at [OSF](https://osf.io/ks325/).

## Onset extraction: Technical details

Onsets were extracted based on envelope characteristics using [Matlab](https://www.mathworks.com) and [MIR Toolbox (1.7)](https://www.jyu.fi/hytk/fi/laitokset/mutku/en/research/materials/mirtoolbox).

Code folder contains the following files:

* `contents.m` is script which allows to replicate the onset extraction accuracy analyses (using F-measure) for a handful of files (sarod, sitar, and guitar) which contained manully annotated ground-truth data (onsets). The output is written to `Accuracy.csv`.

`extract_onset_custom.m` if the function that carried out the extraction and takes in four possible parameters. Currently there has been a light-weight optimisation of the parameters to optimise the accuracy using the annotations.

The folder also contains beat evaluation files from [audio onset detection section of the MIREX competition](http://www.music-ir.org/mirex/wiki/2018:Audio_Onset_Detection), which are `be_confidenceIntervals.m`, `be_evalWrapper.m`, `be_fMeasure`, `be_params.m`. The are ancillary functions that used in calculating the accuracy in the MIREX way.

#### Onset extraction details

1. First the audio signal is band-pass filtered to eliminate frequencies above _900-1200 Hz_ (or any specific threshold) to focus on body resonances of the plucked instruments. 

2. The envelope of the filtered signal is then extracted and subjected to low-pass filtering and half-wave rectification before applying peak-picking. 

3.  Peak-picking algorithm had three parameters to determine (1) _the local contrast threshold value_, (2) _normalised amplitude threshold value_, and (3) _threshold value for the minimum difference between peak values_. This includes temporally precise estimation of the peak time using quadratic interpolation.

#### Estimation of onset detection accuracy

The optimal values for the four parameters were defined for each instrument using a 1-minute sample of manually annotated onsets for a handful of examples (9). These short audio files and annotations are available in the respective folders (`audio` and `groundtruth`). These 9 excerpts are all taken from the Indian corpus, selected and annotated by Martin Clayton. We focussed on these since the onsets in these intruments were challenging to extract whereas some instruments such as tabla are trivially easy. In terms of annotation, Martin Clayton has marked the onsets in Sonic Visualiser and then exported these as csv files (onset times in seconds). These excerpts can be found in `groundtruth` folder.

If you run the `contents.R` in Matlab with the necessary packages (MIR toolbox + the functions from code folder, this will extract the onsets in all files and assess the accuracy using F-score, leading decent hit rates ranging from 73 to 87.
