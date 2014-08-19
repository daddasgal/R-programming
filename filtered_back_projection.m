% The following program performs filtered back projection of a CT data set.

clc;close all;clear all;

%----------------------------------------------------------------------- problem 2-a
%defining rectangular profile
rect(1,15)=0;
rect(5:11)=1;   
sino=rect;
thetas=[15 60 125];

%calling reconstruction function 'recon' and plotting the images for three angles
for x=1:3
    theta=thetas(x);
    bp=recon(theta,sino);
    subplot(1,3,x);imagesc(bp);head='Detector angle =  ';
    title([head  num2str(thetas(x)) ' degrees']); set(gca,'XAxisLocation','top');set(gca,'DataAspectRatio',[1 1 1]);colormap(gray);
end
saveas(gca,'2a.png');

%----------------------------------------------------------------------- recon function
function bp=recon(theta,sino)

r=max(size(sino));
[x y]=meshgrid(-floor(r/2):1:floor(r/2),floor(r/2):-1:-floor(r/2));
eq=x*cosd(theta)+y*sind(theta);
eq(eq<(-floor(r/2)))=-floor(r/2);eq(eq>(floor(r/2)))=floor(r/2);        %values outside range of r are equalized to the max or min values of r
bp=interp1(-floor(r/2):1:floor(r/2),sino,eq);

%------------------------------------------------------------------------ problem 2-b
% plotting the sinogram
load('Prob2.mat');
figure;imagesc(sinogram');set(gca,'DataAspectRatio',[1 1 1]);
set(gca,'XAxisLocation','top');
set(gca,'YTick',1:200:401);set(gca,'YTickLabel',{'0','90','179.5522'});title('Sinogram');
saveas(gca,'2b.png');

%----------------------------------------------------------------------- problem 2-c
% performing complete backprojection of the given sinogram
bp=0;
for z = 1:402
    theta = thetas(z);
    sino = sinogram(:,z);
    bp=bp+recon(theta,sino);                                            %adding the sinograms at all given theta values
end
figure;imagesc(bp);set(gca,'DataAspectRatio',[1 1 1]);set(gca,'XAxisLocation','top');colormap(gray);title('Reconstructed Phantom');
saveas(gca,'2c.png');

%----------------------------------------------------------------------- problem 2-d
%filtered back porjection
ft_sino=fftshift(fft(sinogram,[],1));                                   %FT along R for each value of theta
r=size(ft_sino,1);
rho_filter=abs(-floor(r/2):1:floor(r/2));
rho_filter=repmat(rho_filter,size(ft_sino,2),1);                        %defining rho filter
figure;plot(1:r,rho_filter(1,:));title('Rho Filter');xlabel('Rho');ylabel('Filter magnitude');axis tight;saveas(gcf,'Rho Filter.png');
pre_proc_img=rho_filter'.*ft_sino;                                      %filter FT with rho filter
mod_sino=((ifft(ifftshift(pre_proc_img),[],1)));                        %modified sinogram by taking inverse FT
bp=0;
for z = 1:402
    theta = thetas(z);
    sino = mod_sino(:,z);                                               %use modified sinogram in reconstruction
    bp=bp+recon(theta,sino);
end
figure;imagesc(bp);set(gca,'DataAspectRatio',[1 1 1]);set(gca,'XAxisLocation','top');colormap(gray);title('Filtered Backprojection Phantom');
saveas(gca,'2d.png');

%----------------------------------------------------------------------- problem 3-a
%Downsampling thetas and findind the sinogram at new thetas
%Downsampling by 75% implies 25%(1/4 th) of the samples are retained. Hence every 4th sample is considered. 
%Applying the sampe logic, for 50% (1/2 of samples retained) and 25%(3/4 of samples retained) downsapmling, every 2nd and 1.3rd values are taken for analysis.

theta_75=downsample(thetas,4);sinogram_a_75=downsample(sinogram',4);                            %Taking every 4th value in thetas and sinogram matrices
theta_50=downsample(thetas,2);sinogram_a_50=downsample(sinogram',2);                            %Taking every 2nd value in thetas and sinogram matrices
theta_25=interp1(1:402,thetas,1:(4/3):402);sinogram_a_25=interp1(1:402,sinogram',1:(4/3):402);  %Taking every 1.3rd value in thetas and sinogram matrices

%using the new theta and sinogram to obtained 75% downsampled reconstructed image
ft_sino_a75=fftshift(fft(sinogram_a_75,[],2));
r=size(ft_sino_a75,2);
rho_filter=abs(-floor(r/2):1:floor(r/2));
rho_filter=repmat(rho_filter,size(ft_sino_a75,1),1);
pre_proc_img_a75=rho_filter.*ft_sino_a75;
mod_sino_a75=((ifft(ifftshift(pre_proc_img_a75),[],2)));
bp=0;
for z = 1:101
    theta = theta_75(z);
    sino = mod_sino_a75(z,:);
    bp=bp+recon(theta,sino);
end
figure;imagesc(bp);set(gca,'DataAspectRatio',[1 1 1]);set(gca,'XAxisLocation','top');colormap(gray);title('75% angular downsampling');
saveas(gca,'3a-75.png');

%using the new theta and sinogram to obtained 50% downsampled reconstructed image
ft_sino_a50=fftshift(fft(sinogram_a_50,[],2));
r=size(ft_sino_a50,2);
rho_filter=abs(-floor(r/2):1:floor(r/2));
rho_filter=repmat(rho_filter,size(ft_sino_a50,1),1);
pre_proc_img_a50=rho_filter.*ft_sino_a50;
mod_sino_a50=((ifft(ifftshift(pre_proc_img_a50),[],2)));
bp=0;
for z = 1:101
    theta = theta_50(z);
    sino = mod_sino_a50(z,:);
    bp=bp+recon(theta,sino);
end
figure;imagesc(bp);set(gca,'DataAspectRatio',[1 1 1]);set(gca,'XAxisLocation','top');colormap(gray);title('50% angular downsampling');
saveas(gca,'3a-50.png');

%using the new theta and sinogram to obtained 25% downsampled reconstructed image
ft_sino_a25=fftshift(fft(sinogram_a_25,[],2));
r=size(ft_sino_a25,2);
rho_filter=abs(-floor(r/2):1:floor(r/2));
rho_filter=repmat(rho_filter,size(ft_sino_a25,1),1);
pre_proc_img_a25=rho_filter.*ft_sino_a25;
mod_sino_a25=((ifft(ifftshift(pre_proc_img_a25),[],2)));
bp=0;
for z = 1:101
    theta = theta_25(z);
    sino = mod_sino_a25(z,:);
    bp=bp+recon(theta,sino);
end
figure;imagesc(bp);set(gca,'DataAspectRatio',[1 1 1]);set(gca,'XAxisLocation','top');colormap(gray);title('25% angular downsampling');
saveas(gca,'3a-25.png');

%------------------------------------------------------------------------- problem 3-b            
%Downsampling R and considering only the values at new R's for new sinograms.

sinogram_r_75=downsample(sinogram,4);                                   %every 4th value along R
sinogram_r_50=downsample(sinogram,2);                                   %every 2nd value along R
sinogram_r_25=interp1(1:367,sinogram,1:(4/3):367);                      %every 1.3rd value along R

%using the new theta and sinogram to obtained 75% downsampled reconstructed image
ft_sino_r75=fftshift(fft(sinogram_r_75,[],1));
r=size(ft_sino_r75,1);
rho_filter=abs(-floor(r/2):1:floor(r/2)-1);
rho_filter=repmat(rho_filter,size(ft_sino_r75,2),1);
pre_proc_img_r75=rho_filter.*ft_sino_r75';
mod_sino_r75=ifft(ifftshift(pre_proc_img_r75),[],2)';
bp=0;
for z = 1:402
    theta = thetas(z);
    sino = mod_sino_r75(:,z);
    bp=bp+recon(theta,sino);
end
figure;imagesc(bp');set(gca,'DataAspectRatio',[1 1 1]);set(gca,'XAxisLocation','top');title('75% radial downsampling');colormap(gray);
saveas(gca,'3b-75.png');

%using the new theta and sinogram to obtained 50% downsampled reconstructed image
ft_sino_r50=fftshift(fft(sinogram_r_50,[],1));
r=size(ft_sino_r50,1);
rho_filter=abs(-floor(r/2):1:floor(r/2)-1);
rho_filter=repmat(rho_filter,size(ft_sino_r50,2),1);
pre_proc_img_r50=rho_filter.*ft_sino_r50';
mod_sino_r50=ifft(ifftshift(pre_proc_img_r50),[],2)';
bp=0;
for z = 1:402
    theta = thetas(z);
    sino = mod_sino_r50(:,z);
    bp=bp+recon(theta,sino);
end
figure;imagesc(bp');set(gca,'DataAspectRatio',[1 1 1]);set(gca,'XAxisLocation','top');title('50% radial downsampling');colormap(gray);
saveas(gca,'3b-50.png');

%using the new theta and sinogram to obtained 25% downsampled reconstructed image
ft_sino_r25=fftshift(fft(sinogram_r_25,[],1));
r=size(ft_sino_r25,1);
rho_filter=abs(-floor(r/2):1:floor(r/2));
rho_filter=repmat(rho_filter,size(ft_sino_r25,2),1);
pre_proc_img_r25=rho_filter.*ft_sino_r25';
mod_sino_r25=ifft(ifftshift(pre_proc_img_r25),[],2)';
bp=0;
for z = 1:402
    theta = thetas(z);
    sino = mod_sino_r25(:,z);
    bp=bp+recon(theta,sino);
end
figure;imagesc(bp');set(gca,'DataAspectRatio',[1 1 1]);set(gca,'XAxisLocation','top');title('25% radial downsampling');colormap(gray);
saveas(gca,'3b-25.png');

%----------------------------------------------------------------------- problem 5
load('Prob5.mat')

sinogram=radon(im0',thetas);                                            %obtaining the sinogram from the given image

s1=interp1(127:367,sinogram(127:367,:),124:126,'linear','extrap');		%extrapolation to fill in discontinuities
sinogram(124:126,:)=s1;                                                 %new sinogram
imagesc(sinogram');                                                     

ft_sino=fftshift(fft(sinogram,[],1));                                   %FT along R for each value of theta
r=size(ft_sino,1);
rho_filter=abs(-floor(r/2):1:floor(r/2));
rho_filter=repmat(rho_filter,size(ft_sino,2),1);                        %defining rho filter
pre_proc_img=rho_filter'.*ft_sino;                                      %filter FT with rho filter
mod_sino=((ifft(ifftshift(pre_proc_img),[],1)));                        %modified sinogram by taking inverse FT
bp=0;
for z = 1:402
    theta = thetas(z);
    sino = mod_sino(:,z);                                               %use modified sinogram in reconstruction
    bp=bp+recon(theta,sino);
end
figure;imagesc(bp);set(gca,'DataAspectRatio',[1 1 1]);set(gca,'XAxisLocation','top');colormap(gray);title('Filtered Backprojection Phantom');