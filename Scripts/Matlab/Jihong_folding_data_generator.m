function Jihong_folding_data_generator(FileNameRoot)
%function Jihong_folding_data_generator(FileNameRoot)
%No change is necessary below

fid=fopen([FileNameRoot '.txt']);
a = textscan(fid, '%s','delimiter', '\n');
fclose(fid);
a=a{1,:};

% % make a while loop to load them into their own variables
i=1;
count=1;
while i<=size(a,1)
    c=a{i};
    c2=strcat(c(1:end));
    c2_temp=strsplit(c2,' ');
    RNAname{count,1}=c2_temp{1};
    RNAfasta{count,1}=c2_temp{2};
    RNAcen{count,1}=c2_temp{3};
    RNAcenVAL{count,1}=c2_temp{4};
    count=count+1;
    i=i+1;
end

disp('finished reading');

save ([FileNameRoot '.mat'], 'RNAfasta', 'RNAcen', 'RNAname', 'RNAcenVAL');
