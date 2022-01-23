function[iirTime,iirFreq,outputGain1]=iirFilter(range1,range2,fs,y,input)
                    N=2;
                    FN=fs/2;
                    w1=range1/FN;
                    w2=range2/FN;
                    if w1 == 0
                        wn = w2;
                    else
                        wn=[w1 w2];
                    end
                    [numd,dend]=butter(N,wn); %specify the digital filter transfer function
                    [z,p,k]=butter(N,wn);
                    str = sprintf('Gain of IIR filter %d -> %d Hz',range1,range2);
                    disp(str);
                    disp(k);
                    [hd,wd]=freqz(numd,dend); %provide the frequency response of digital filter
                    mag=abs(hd); %compute the magnitude response
                    phase=angle(hd)*180/pi; %compute the phase response
                    figure;
                    subplot(2,1,1)
                    plot(wd/pi,mag)
                    str = sprintf('Magnitude of IIR filter %d -> %d Hz',range1,range2);
                    title(str)
                    subplot(2,1,2)
                    plot(wd/pi,phase)
                    str = sprintf('Phase of IIR filter %d -> %d Hz',range1,range2);
                    title(str)
                     % impulse response
                    imp=[1 zeros(1,60)];
                    imp_response=filter(numd,dend,imp);
                    figure
                    stem(imp_response)
                    str = sprintf('Impulse response IIR filter %d-%d Hz',range1,range2);
                    title(str)
                    % unit response of filter
                    unit=ones(1,61);
                    unit_response=filter(numd,dend,unit);
                    figure
                    stem(unit_response)
                    str = sprintf('Unit step response IIR filter %d-%d Hz',range1,range2);
                    title(str)
                     % plotting zeros and poles
                     figure;
                    zplane(z,p)
                    str = sprintf('Zeros-poles plot of IIR filter %d->%d Hz',range1,range2);
                    title(str)
                    % applying filter to the original wave
                    iirTime=filter(numd,dend,y);
                    outputGain1=(input).*(iirTime);% multiply output signal with gain
                    figure;
                    subplot(2,1,1);
                    plot(iirTime);
                    [iirFreq,w]=freqz(iirTime);
                    str = sprintf('Output signal after IIR filter %d -> %d Hz in time domain',range1,range2);
                    title(str)
                    subplot(2,1,2);
                    plot(w/pi,abs(iirFreq))
                    str = sprintf('Output signal after IIR filter %d -> %d Hz in frequency domain',range1,range2);
                    title(str)
end