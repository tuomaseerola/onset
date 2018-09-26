# Onset detection in the Interpersonal Entrainment in Musical Performance

Onset detection is a well-established research area in MIR and there are multiple efficient solutions for extraction onsets from various types of musical materials<a href="#note1" id="note1ref"><sup>1</sup></a>. In the context of [Interpersonal Entrainment in Musical Performance (IEMP)](https://www.dur.ac.uk/iemp/), AHRC-funded research project, we wanted explore how tightly or loosely musicians in different ensembles synchronise to each other. For this, we needed to extract onsets from diverse range of multitrack audio recordings. We wanted to rely on a conventional onset extraction technique that would be applied to as many different kinds of onsets in order to make the temporal comparison of different instruments comparable. Also, we wanted to keep the temporal resolution of the onset estimation high, much higher than the often used tolerance in the onset detection evaluation (e.g., 80 ms).

## Audio materials
- Musical material in the [IEMP](https://www.dur.ac.uk/iemp/) project ranges from jembe music of West Africa to North Indian classical music to Western jazz.
- IEMP Collection with annotations, audio and videos can be found at [OSF](https://osf.io/ks325/).

## Onset extraction: Technical details

Onsets were extracted based on envelope characteristics using [Matlab](https://www.mathworks.com) and [MIR Toolbox (1.7)](https://www.jyu.fi/hytk/fi/laitokset/mutku/en/research/materials/mirtoolbox).

Code folder contains the following files:

* `contents.m` is script which allows to replicate the onset extraction accuracy analyses (F-measure) for a handful of files (sarod, sitar, and guitar) which contained manully annotated ground-truth data (onsets). The output is written to `Accuracy.csv`.

`extract_onset_custom.m` if the function that carried out the extraction and takes in four possible parameters. Currently there has been a light-weight optimisation of the parameters to optimise the accuracy using the annotations.

The folder also contains beat evaluation files from [audio onset detection section of the MIREX competition](http://www.music-ir.org/mirex/wiki/2018:Audio_Onset_Detection), which are `be_confidenceIntervals.m`, `be_evalWrapper.m`, `be_fMeasure`, `be_params.m`. The are ancillary functions that used in calculating the accuracy in the MIREX way.

#### Onset extraction details

1. First the audio signal is band-pass filtered to eliminate frequencies above _900-1200 Hz_ (or any specific threshold) to focus on body resonances of the plucked instruments. 

    <code>
        a_low = mirfilterbank(file,'Manual',[-Inf ext_params(4)],'Hop',1);
        % Frequency Filtering, default 900Hz (cut anything above
    </code>

2. The envelope of the filtered signal is then extracted and subjected to low-pass filtering and half-wave rectification before applying peak-picking. 

<code>
a_low = mirenvelope(a_low,'Tau',0.01,'HalfwaveDiff','Smooth',2,'Normal');
% low-pass filtering for 0.01 + Halfwave differencing
% And Smoothing with average of order 2.
</code>


3.  Peak-picking algorithm had three parameters to determine (1) _the local contrast threshold value_, (2) _normalised amplitude threshold value_, and (3) _threshold value for the minimum difference between peak values_. This includes temporally precise estimation of the peak time using quadratic interpolation.

<code>
o_low = mirpeaks(a_low,'Contrast',ext_params(1),...
'Threshold',ext_params(2),'Reso',ext_params(3),'Loose','Order','abscissa'); 
</code>

#### Estimation of accuracy

The optimal values for the four parameters were defined for each instrument using a 1-minute sample of manually annotated onsets and customised for each main instrument types (sitar, sarod, and guitar, etc.). This customisation lead to accuracies (F scores) of 73 to 87.

#### Caveats

A number of other onset detection techniques (e.g, spectral difference, phase deviation, etc.) could have been used. There are several widely available tools (e.g., _Sonic Visualiser_) for onset extraction, but we were not satisfied with accuracy and options these tools provided for our project. 


<a id="note1" href="#note1ref"><sup>1</sup></a>[Bello, J.P., Daudet, L., Abdallah, S., Duxbury, C., Davies, M., Sandler, M.B. (2005) "A Tutorial on Onset Detection in Music Signals", IEEE Transactions on Speech and Audio Processing 13(5), pp 1035–1047](http://www.iro.umontreal.ca/~pift6080/H09/documents/papers/bello_onset_tutorial.pdf).