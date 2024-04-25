%%Plot T1 dispersion from ROI
%%Created 16.02.2022


%% parameters
[filename,path] = uigetfile('*.h5','Select the HDF5 file from TGV');
cd(path)

%% data import
%==== set Bevo ===================
bevo = [200,21.1,2.2,0.2]*1e-3;
    
s=h5info(filename);
itn = size(s.Datasets)-2; %find number of iterations
data = h5read(filename,'/tgv_result_iter_19');
n_fields = round((size(data.r,4)-1)/2);
im = abs(data.r(:,:,end-n_fields+1:end)+1i*data.i(:,:,end-n_fields+1:end));

      
%% Display T1 map
figure
imagesc(abs(im(:,:,3)));


%% T1 stroke from T1 map
title('Draw the ROI for the stroke region')
mask_s = roipoly;
T1s = zeros(size(im,3),1);
dT1s = zeros(size(im,3),1);
for i=1:size(im,3)
   im_ = im(:,:,i);
   T1s(i) = mean(im_(mask_s(:))); 
   dT1s(i) = std(im_(mask_s(:)));
end
   
%T1 contralateral from T1 map
title('Draw the ROI for the contralateral region')
mask_H = roipoly;
T1H = zeros(size(im,3),1);
dT1H = zeros(size(im,3),1);
for i=1:size(im,3)
   im_ = im(:,:,i);
   T1H(i) = mean(im_(mask_H(:))); 
   dT1H(i) = std(im_(mask_H(:)));
end

       
%%T1 dispersion
figure
errorbar(bevo/1000,T1s/1000,dT1s/1000, '-rs')
hold on
errorbar(bevo/1000,T1H/1000,dT1H/1000, '-bs')
set(gca, 'XScale','log', 'YScale','log')
ylabel('T1 Relaxation time (s)')
xlabel('Evolution field (T)')
legend({'Infarct region','Matched contralateral region'},'location','southeast')
