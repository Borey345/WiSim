function simulate()
% signalObj = Signal();
interferenceObj = Signal();

channelObj = Channel();
outSig = interferenceObj.getSignal();
outSig = channelObj.out(outSig);


end