function [H, delay] = scmWrap(nBsAntennas, nMsAntennas)
scmPar = scmparset();
scmPar.Scenario = 'urban_macro';
scmPar.BsUrbanMacroAS = 'fifteen';
scmPar.NumMsElements = nMsAntennas;
scmPar.NumBsElements = nBsAntennas;
scmPar.NumTimeSamples = 1;
linkPar = linkparset();
antennaPar = antparset;
[H, delay] = scm(scmPar, linkPar, antennaPar);