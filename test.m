I =imread('Cr_20.bmp');

I=im2double(I);

I = adapthisteq(I);

figure,imshow(I);


%% 频域处理锐化

% g = fft2(I);
% g = fftshift(g);
% [M,N] = size(g);
% m=fix(M/2);
% n=fix(N/2);
% 
% for i=1:M
% 	for j=1:N
% 		D=sqrt((i-m)^2+(j-n)^2);
% 		H=exp(-(D.^2)./(2*(D.^2)));
% 		result(i,j)=(1-H)*g(i,j);
% 
% 	end
% end
% result=ifftshift(result);
% J1=ifft2(result);
% J2=uint8(real(J1));% 高斯高通滤波后的图像
% figure,imshow(J1);
% 
% %高频强调滤波
% F=0.5+0.75*(1-H);
% G=F*g;
% result2=ifftshift(G);
% J3=ifft2(result2);% 高斯强调滤波后的图像

%高通滤波器
[height, width] = size(I);
		FTransform = fft2(I);
		FTransformCenter = fftshift(FTransform);
		
		%Ideal low-pass
		IdealLowPass = zeros(height, width);
		IdealHighPass = zeros(height, width);
		mid_width = width / 2;
		mid_height = height / 2;
		DLThreshold = 30;
		DLThresholdExp2 = DLThreshold ^ 2;
		DHThreshold = 10;
		DHThresholdExp2 = DHThreshold ^ 2;
		%这里是选定一个值作为需要的范围
		for row = 1:height
		    for col = 1:width
		        %Ideal low-pass
		        temp = ((row - mid_height)^2 + (col - mid_width)^2);
		        if temp < DLThresholdExp2
		            IdealLowPass(row, col) = 1;
		        end
		        if temp > DHThresholdExp2
		            IdealHighPass(row, col) = 1;
		        end
		    end
		end
		%小于范围值的地方取1，大于范围值的地方取0就是低通，相反就是高通
		%下面直接点乘=想要的直接留下来
		DLprocessCenter = IdealLowPass .* FTransformCenter;
		DLprocess = fftshift(DLprocessCenter);
        ImgDLprocess = ifft2(DLprocess);

		DHprocessCenter = IdealHighPass .* FTransformCenter;
		DHprocess = fftshift(DHprocessCenter);
		ImgDHprocess = ifft2(DHprocess);
		
        figure;
		subplot(1, 3, 1)
		imshow(I), title('Origin');
		subplot(1, 3, 2)
		imshow(ImgDLprocess), title('The Fourier transform base on Ideal low-pass');
		subplot(1, 3, 3)
		imshow(ImgDHprocess), title('The Fourier transform base on Ideal high-pass');

%频域叠加高通，强化边缘

FTransform=FTransform+DHprocess;
Iinhense=ifft2(FTransform);
figure,imshow(Iinhense);