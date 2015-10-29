#!/bin/bash
set -o errexit
set -o nounset

HZZ=${HZZ:-0}

# Check CMSSW version
MAJOR_VERSION=`echo $CMSSW_VERSION | sed "s|CMSSW_\([0-9]\)_.*|\1|"`
MINOR_VERSION=`echo $CMSSW_VERSION | sed "s|CMSSW_\([0-9]\)_\([0-9]\)_.*|\2|"`


# Tags for 7XX

pushd $CMSSW_BASE/src

# electron and photon id
git cms-merge-topic ikrav:egm_id_7.4.12_v1

# 74X met corrections (no HF)
#git cms-merge-topic -u cms-met:METCorUnc74X

# HZZ MELA, MEKD etc.
if [ "$HZZ" = "1" ]; then
    echo "Checking out ZZ MELA and Higgs combine"
    git clone https://github.com/cms-analysis/HiggsAnalysis-ZZMatrixElement.git ZZMatrixElement
    git clone -b 74x-root6 https://github.com/cms-analysis/HiggsAnalysis-CombinedLimit.git HiggsAnalysis/CombinedLimit
fi

if [ "$HTT" = "1" ]; then
    echo "Checking out HTT material: mva met and svFit"
    git clone git@github.com:veelken/SVFit_standalone.git TauAnalysis/SVfitStandalone
    cd TauAnalysis/SVfitStandalone
    git checkout svFit_2015Apr03
    cd ../..

    git cms-addpkg RecoMET/METPUSubtraction
    cd RecoMET/METPUSubtraction/
    git clone https://github.com/rfriese/RecoMET-METPUSubtraction data -b 74X-13TeV-Summer15-July2015
    git clone https://github.com/cms-data/RecoMET-METPUSubtraction.git

    echo "####################################################################"
    echo "###   Go Edit: RecoMET/METPUSubtraction/python/mvaPFMET_cff.py   ###"
    echo "###   Add at line 41:    etaBinnedWeights = cms.bool(False),     ###"
    echo "###   And await a real fix...                                    ###"
    echo "####################################################################"

fi

popd

