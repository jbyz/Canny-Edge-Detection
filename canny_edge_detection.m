clear variables; close all; clc;

%% ======= LAB 1 =======

%% ----- Task 1 -----
% Importing image into a matrix
img_data = imread('test00.png');
if size(img_data,3) == 3 % Make image gray if otherwise
    img_data = rgb2gray(img_data);
end

% Displaying original image
figure(1)
imshow(img_data)

% Gaussian blur kernel
Gauss_blur = [ 2 4 5 4 2; 4 9 12 9 4; 5 12 15 12 5; 4 9 12 9 4; 2 4 5 4 2 ]./159;

% Applying the blur to the image
[img_Gauss] = apply_filter(Gauss_blur, img_data);

% Displaying blurred image
figure(2)
imshow(img_Gauss,[])
title('Image with Gaussian blur')

%% ----- Task 2 -----

% Sobel kernel
Sobel_Gx = [ -1 0 1; -2 0 2; -1 0 1];   % Gx
Sobel_Gy = transpose(Sobel_Gx); % Gy

[Gx] = apply_filter(Sobel_Gx, img_data);  % Gradient in x
[Gy] = apply_filter(Sobel_Gy, img_data);  % Gradient in y

% Displaying filtered image
figure(3)
imshow(Gx,[])
title('Sobel filtered Image in Gx direction')

figure(4)
imshow(Gy,[])
title('Sobel filtered Image in Gy direction')

%% ----- Task 3 -----
Sobel_Mg = sqrt( Gx.^2 + Gy.^2);    % finding gradient magnitude

% Displaying gradient magnitude
figure(5)
imshow( Sobel_Mg, [])
title('Gradient Magnitude')

%% ----- Task 4 -----
Grad_Orient = atan2d(Gy, Gx) + 360*(Gy<0); % finding gradient orientation

% Rounding orientation values to nearest 45 degrees
Grad_Orient( (22.5>=Grad_Orient) | (Grad_Orient>337.5) ) = 0;   % E
Grad_Orient( (67.5>=Grad_Orient) & (Grad_Orient>22.5) ) = 45; % NE
Grad_Orient( (112.5>=Grad_Orient) & (Grad_Orient>67.5) ) = 90; % N
Grad_Orient( (157.5>=Grad_Orient) & (Grad_Orient>112.5) ) = 135; % NW
Grad_Orient( (202.5>=Grad_Orient) & (Grad_Orient>157.5) ) = 180; % W
Grad_Orient( (247.5>=Grad_Orient) & (Grad_Orient>202.5) ) = 225; % SW
Grad_Orient( (292.5>=Grad_Orient) & (Grad_Orient>247.5) ) = 270; % S
Grad_Orient( (337.5>=Grad_Orient) & (Grad_Orient>292.5) ) = 315; % SE

% Displaying gradient orientation
figure(6)
imshow(Grad_Orient, [] )
title('Gradient Orientation')

% Displaying gradient orientation with colors
figure(7)
imagesc(Grad_Orient)
title('Gradient Orientation with colors')


%% ----- Task 5 -----
[row_len,col_len] = size(Sobel_Mg); % getting dimensions
Mg_non_maxima = Sobel_Mg;   % creating a copy to edit

for col = 1:row_len-2
    for row = 1:col_len-2
        img_window = Sobel_Mg(col:col+2,row:row+2); % extract 3x3 window
        
        % Identifying gradient direction for each pixel
        switch Grad_Orient(col+1, row+1)
            case {0,180}
                if img_window(2,2) < max(img_window(2,1),img_window(2,3))
                   img_window(2,2) = 0; % supress if smaller than pixels on both sides
                end
            case {45,225}
                if img_window(2,2) < max(img_window(1,3),img_window(3,1))
                   img_window(2,2) = 0;
                end
            case {90,270}
                if img_window(2,2) < max(img_window(1,2),img_window(3,2))
                   img_window(2,2) = 0;
                end
            case {135,315}
                if img_window(2,2) < max(img_window(1,1),img_window(3,3))
                   img_window(2,2) = 0;
                end        
        end
        % updating matrix with suppresed values if any
        Mg_non_maxima(col+1,row+1) = img_window(2,2);
        
    end
end

% ---- Thresholding ----
% removing pixel if magnitude is less than 300
Mg_non_maxima(Mg_non_maxima<300) = 0;
Mg_non_maxima(Mg_non_maxima>=300) = 1;

% Displaying supressed and thresholded image
figure(8)
imshow(Mg_non_maxima,[])
title('Non Maxima Supression & Thresholding')

%% END OF CODE