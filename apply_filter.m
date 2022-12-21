function [img_filtered] = apply_filter(filter, img_data)
%%% Inputs: 
%%%         filter - a square matrix with filter values
%%%         img_data - image matrix
%%% Output: 
%%%         img_filtered - image matrix with applied filter

[row_len,col_len] = size(img_data); % obtaining size
kernel_sz = size(filter,1) - 1; % obtaining kernel size based on filter size
img_filtered = zeros(row_len-kernel_sz, col_len-kernel_sz); % pre-allocating

for col = 1:row_len-kernel_sz
    for row = 1:col_len-kernel_sz
        % Selecting image window
        img_window = double(img_data(col:col+kernel_sz,row:row+kernel_sz));
        filter_window =  (filter .* img_window); % applying filter to window
        img_filtered(col,row) = sum( filter_window(:) ); % populating filtered matrix
    end
end
