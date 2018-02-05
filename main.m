close all
im_raw = imread('data\00056v.jpg');
im_raw = im2double(im_raw);
%% Using Hough Transform to correct rotation
edge_raw = edge(im_raw, 'canny');
[H theta R] = hough(edge_raw,'Theta', -0.01:0.001:0.01);
H_peak = houghpeaks(H);
figure, subplot(121), imshow(im_raw);
im_raw = imrotate(im_raw, theta(H_peak(2)));
subplot(122), imshow(im_raw);
fprintf("Raw_image rotate: %f.\n", theta(H_peak(2)));
%%
%imshow(im_raw);
[raw_height width] = size(im_raw);
height = floor(raw_height/3);
B = im_raw(1:height,:);
G = im_raw(height+1:height*2, :);
R = im_raw(height*2+1:height*3, :);
new_im = cat(3,R,G,B);
figure,imshow(new_im);
ref = R;
[aG G_mov_x G_mov_y] = align(G, ref, 'ssd',3);
[aB B_mov_x B_mov_y] = align(B, ref, 'ssd',3);
aligned_im = cat(3,ref,aG,aB);
figure,imshow(aligned_im);
%% 
[aligned_w, aligned_h, depth] = size(aligned_im);
x_crop = max(abs(G_mov_x), abs(B_mov_x));
y_crop = max(abs(G_mov_y), abs(B_mov_y));
x_min = x_crop;
y_min = y_crop;
crop_w = aligned_w - 2 * x_crop;
crop_h = aligned_h - 2 * y_crop;
final = imcrop(aligned_im, [x_min y_min crop_w crop_h]);
