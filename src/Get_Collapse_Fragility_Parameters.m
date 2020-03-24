function [CollapseSDR,CPS_Option,MedianCPS,SigmaCPS,Pcollapse,PcollapseSa]=Get_Collapse_Fragility_Parameters(app)


if app.radio1.Value==1
    CPS_Option=0;
    MedianCPS = 10;
    SigmaCPS  = 0.001;
    Pcollapse=1;
    PcollapseSa=1;
    CollapseSDR=0.15;
end

if app.radio2.Value==1
    CPS_Option=1;
    CollapseSDR=app.edit1.Value;
    [EmpDist,MedianCPS, SigmaCPS]=Get_Collapse_Fragility_IDA(CollapseSDR);
    MedianCPS=exp(MedianCPS);
    Pcollapse=1;
    PcollapseSa=1;
end

if app.radio3.Value==1
    CPS_Option=2;
    MedianCPS = app.edit2.Value;
    SigmaCPS  = app.edit3.Value;
    Pcollapse=1;
    PcollapseSa=1;
    CollapseSDR=0.15;
end

if app.radio4.Value
    CPS_Option=3;
    Pcollapse    = app.edit4.Value/100;
    PcollapseSa  = app.edit5.Value;
    SigmaCPS  = app.edit6.Value;
    CollapseSDR=0.15;
    
    % Get the median Sa at collaspe that satisifies the entered data
    count=1;
    for Sa=0:0.01:5
        MedianSA=(log(Sa)); % Mean of Logarithmic SA Collapse Values
        Probability = logncdf(PcollapseSa,MedianSA,SigmaCPS);
        Diff(count,1)=abs(Probability-Pcollapse);
        count=count+1;
    end
    [MinErr, indexMin]=min(Diff);
    Sa=0:0.01:5;
    MedianCPS=Sa(1,indexMin);
end


end