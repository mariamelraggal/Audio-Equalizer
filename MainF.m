clc
clear 
close all

% get user input
while true
    prompt=('Choose from the following: 1- Start 2- Exit');
    choice=str2double(inputdlg(prompt));
    switch  choice
        % choose to start program
        case 1
            close all 
            %get sound file from user and read it
            fprintf('Choose sound file:\n');
            [file,path] = uigetfile('*.wav');
            [y,FS]=audioread(file);
               if FS<=32000
                   fs=35000;
               end
            % get gain for frequency bands from user
            prompt2 = {'Gain of 0-170 Hz','170-310Hz','310-600Hz','600-1000Hz','1000-3000Hz','3000-6000Hz','6000-12000Hz','12000-14000Hz','14000-16000Hz'};
            answer=inputdlg(prompt2);
            gain = 0;
            for j= 1:9
            gain= [gain db2mag(str2double(answer(j)))];
            end
            inputs = gain(2:end);
            % ask user to choose type of filter
            prompt1 = {'Types of filter 1-FIR    2-IIR'};
            filterType = inputdlg(prompt1);
            filterType = str2double(filterType);
            % ask user to enter output rate
            prompt1 = {'Output sample rate'};
            Sample_Rate = inputdlg(prompt1);
            outputSampleRate = str2double(Sample_Rate);
            switch filterType
                %% FIR
                case 1
                    [firTime1,firFreq1,outputGain1]=firFilter(0,170,fs,y,inputs(1));
                    [firTime2,firFreq2,outputGain2]=firFilter(170,310,fs,y,inputs(2));
                    [firTime3,firFreq3,outputGain3]=firFilter(310,600,fs,y,inputs(3));
                    [firTime4,firFreq4,outputGain4]=firFilter(600,1000,fs,y,inputs(4));
                    [firTime5,firFreq5,outputGain5]=firFilter(1000,3000,fs,y,inputs(5));
                    [firTime6,firFreq6,outputGain6]=firFilter(3000,6000,fs,y,inputs(6));
                    [firTime7,firFreq7,outputGain7]=firFilter(6000,12000,fs,y,inputs(7));
                    [firTime8,firFreq8,outputGain8]=firFilter(12000,14000,fs,y,inputs(8));
                    [firTime9,firFreq9,outputGain9]=firFilter(14000,16000,fs,y,inputs(9));
                   
                    %% concatenate signals in time domain
                    FinalSignalTime=outputGain1+outputGain2+outputGain3+outputGain4+outputGain5;
                    FinalSignalTime=FinalSignalTime+ outputGain6+ outputGain7 +outputGain8+ outputGain9;
                     if outputSampleRate <= 0
                        outputSampleRate = FS;
                     end
                    outputRate=outputSampleRate;
                    outputSampleRate=outputSampleRate/FS;
                    [num,den]=rat(outputSampleRate);
                    FinalSignalTime=resample(FinalSignalTime,num,den);
                    FinalSignalFreq = (fft(FinalSignalTime));
                    t=linspace(-outputRate/2,outputRate/2,length(FinalSignalTime));
                    figure;
                    subplot(2,2,1)
                    plot(y)
                    title('original signal in time domain');
                    subplot(2,2,2)
                    plot(t,FinalSignalTime)
                    title('output composite FIR signal in time domain');
                    subplot(2,2,3)
                    plot(abs(fft(y)))
                    title('original signal in freqency domain');
                    subplot(2,2,4)
                    plot(abs(FinalSignalFreq))
                    title('output composite FIR signal in freqency domain');
                    sound(FinalSignalTime);                    
                %% IIR
                case 2
                    [iirTime1,iirFreq1,outputGain11]=iirFilter(0,170,fs,y,inputs(1));
                    [iirTime2,iirFreq2,outputGain22]=iirFilter(170,310,fs,y,inputs(2));
                    [iirTime3,iirFreq3,outputGain33]=iirFilter(310,600,fs,y,inputs(3));
                    [iirTime4,iirFreq4,outputGain44]=iirFilter(600,1000,fs,y,inputs(4));
                    [iirTime5,iirFreq5,outputGain55]=iirFilter(1000,3000,fs,y,inputs(5));
                    [iirTime6,iirFreq6,outputGain66]=iirFilter(3000,6000,fs,y,inputs(6));
                    [iirTime7,iirFreq7,outputGain77]=iirFilter(6000,12000,fs,y,inputs(7));
                    [iirTime8,iirFreq8,outputGain88]=iirFilter(12000,14000,fs,y,inputs(8));
                    [iirTime9,iirFreq9,outputGain99]=iirFilter(14000,16000,fs,y,inputs(9));
                      
                    %% concatenate signals in freqnecy domain
                    FinalSignalTimeIIR=outputGain11+ outputGain22+ outputGain33+ outputGain44+outputGain55;
                    FinalSignalTimeIIR=FinalSignalTimeIIR+  outputGain66+ outputGain77+ outputGain88+ outputGain99;
                    if outputSampleRate <= 0
                        outputSampleRate = FS;
                    end
                    outputRate=outputSampleRate;
                    outputSampleRate=outputSampleRate/FS;
                    [num,den]=rat(outputSampleRate);
                    FinalSignalTimeIIR=resample(FinalSignalTimeIIR,num,den);
                    t=linspace(-outputRate/2,outputRate/2,length(FinalSignalTimeIIR));
                    FinalSignalFreqIIR =(fft(FinalSignalTimeIIR));
                    figure;
                    subplot(2,2,1)
                    plot(y)
                    title('original signal in time domain');
                    subplot(2,2,2)
                    plot(t,FinalSignalTimeIIR)
                    title('output composite IIR signal in time domain');
                    subplot(2,2,3)
                    plot(abs(fft(y)))
                    title('original signal in freqency domain');
                    subplot(2,2,4)
                    plot(abs(FinalSignalFreqIIR))
                    title('output composite IIR signal in freqency domain');
                    sound(FinalSignalTimeIIR);
                otherwise
                     fprintf('Error: you have to choose either 1 or 2.\nTry Again\n\n\n');
            end
            % choose to exit program
        case 2
            break
        otherwise
            fprintf('Error: you have to choose either 1 or 2.\nTry Again\n\n\n');
        
    end
end