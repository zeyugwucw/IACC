function new_im = crop(im)
 im_gau = imgaussfilt(im,3);
 [w h] = size(im);
 threshold = 0.05;
 col_r = var(im_gau(:,:,1), 0, 1);
 col_g = var(im_gau(:,:,2), 0, 1);
 col_b = var(im_gau(:,:,3), 0, 1);
 col = col_r + col_g + col_b;
 row_r = var(im_gau(:,:,1), 0, 2);
 row_g = var(im_gau(:,:,2), 0, 2);
 row_b = var(im_gau(:,:,3), 0, 2);
 row = row_r + row_g + row_b;
 
 sort_row = sort(row);
 sort_col = sort(col);
 row_threshold = sort_row(round(h*threshold));
 col_threshold = sort_col(round(w*threshold));
 row_high_idx = find(row>row_threshold);
 col_high_idx = find(col>col_threshold);
 row_min = min(row_high_idx);
 row_max = max(row_high_idx);
 col_min = min(col_high_idx);
 col_max = max(col_high_idx);
 new_im = im(row_min:row_max, col_min:col_max,:);
end