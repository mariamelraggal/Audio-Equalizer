function[firTime,firFreq,outputGain]=firFilter(range1,range2,fs,y,input)
                    FN1=fs/2;
                    N=20;
                    w1=range1/FN1;
                    w2=range2/FN1;
                    %cutoff frequency vector 
                    if w1 == 0
                        wc = w2;
                    else
                        wc=[w1 w2];
                    end
                    b=fir1(N,wc); %coefficients of FIR filter 
                                        
                    [H0,f]=freqz(b,1); %frequency response
                    figure
                    mag2=abs(H0);
                    subplot(2,1,1);
                    plot(f/pi,mag2);
                    str = sprintf('Magnitude of FIR filter %d -> %d Hz',range1,range2);
                    title(str)
                    phase2=angle(H0)*180/pi;
                    subplot(2,1,2);
                    plot(f/pi,phase2);
                    str = sprintf('Phase of FIR filter %d -> %d Hz',range1,range2);
                    title(str)
                    % impulse response
                    imp2=[1 zeros(1,60)];
                    imp_response2=filter(b,1,imp2);
                    figure
                    stem(imp_response2);
                    str = sprintf('Impulse response FIR filter %d-%d Hz',range1,range2);
                    title(str)
                    % unit response of filter
                    unit2=ones(1,61);
                    unit_response2=filter(b,1,unit2);
                    figure
                    stem(unit_response2)
                    str = sprintf('Unit response FIR filter %d-%d Hz',range1,range2);
                    title(str)
                      % gain of filter
                    [z,p,k]=tf2zpk(b,1);
                    str = sprintf('Gain of FIR filter %d -> %d Hz',range1,range2);
                    disp(str);
                    disp(k);
                    % zeros of filter 
                    figure;
                    zplane(z,p)
                  
                    str = sprintf('Zeros of FIR filter %d -> %d Hz',range1,range2);
                    title(str)
                    % output of wave with filter 170->310
                    figure;
                    subplot(2,1,1);
                    firTime=filter(b,1,y);
                    outputGain=(input).*(firTime); % multiply output signal with gain
                    plot(firTime)
                    str = sprintf('Output signal after FIR filter %d -> %d Hz in time',range1,range2);
                    title(str)
                    [firFreq,w]=freqz(firTime);
                    subplot(2,1,2);
                    plot(w/pi,abs(firFreq));
                    str = sprintf('Output signal after FIR filter %d -> %d Hz in frequency',range1,range2);
                    title(str)            
end