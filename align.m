function [aligned_img mov_x mov_y] = align(img, ref_img, method, pyramid)
if nargin == 2
    method = 'ssd';
    pyramid = 0;
end
if nargin == 3
    pyramid = 0;and
end
match_percent=0.95;
if pyramid ~= 0
    fprintf('Using pyramid factor: %f, method: %s\n',pyramid, method)
    hor_shift = 0;
    ver_shift = 0;
    [w, h] = size(ref_img);
    first_max_shift = 20;
    ver=0;
    hor=0;
    for pyramid_level=pyramid:-1:0
        % Global shift        
        resize_factor = (1/2)^pyramid_level;
        [py_w, py_h] = size(imresize(ref_img, resize_factor));
        match_r = int32(py_w * match_percent);
        match_l = int32(py_w * (1 - match_percent));
        match_b = int32(py_h * match_percent);
        match_t = int32(py_h * (1 - match_percent));
        min_loss = inf;
        scl = 1;
        shifited_img = circshift(img, [hor_shift, ver_shift]);
        pyramid_img = imresize(shifited_img, resize_factor*scl);
        pyramid_img = pyramid_img(match_l:match_r, match_t:match_b);
        pyramid_img = mat2gray(histeqlzer(uint8(pyramid_img*255)));
        pyramid_img = edge(pyramid_img, 'log');
        pyramid_ref = imresize(ref_img, resize_factor);
        pyramid_ref = pyramid_ref(match_l:match_r, match_t:match_b);
        pyramid_ref = mat2gray(histeqlzer(uint8(pyramid_ref*255)));
        pyramid_ref = edge(pyramid_ref, 'log');
        [ref_w, ref_h] = size(pyramid_ref);
        if pyramid_level == pyramid
            max_shift = first_max_shift;
        else
            %if max(abs(hor_shift), abs(ver_shift)) ~= 0
            %max_shift = ceil((max([abs(hor), abs(ver), 1]) * 2));
            max_shift = 2;
        end
        for i=-max_shift:max_shift
            for j=-max_shift:max_shift
                for k = 1.000:0.0003:1.000
                    shift = circshift(pyramid_img, [i, j]);
                    scale = shift;
%                     scale = imresize(shift,k);
%                     if k > 1
%                         scale = scale(1:ref_w, 1:ref_h);
%                     else
%                         scale(ref_w, ref_h) = 0;
%                     end
                    if strcmp(method, 'ssd')
                        loss = sum(sum((scale - pyramid_ref).^2));
                    else
                        loss = dot(reshape(scale,1,[])./norm(reshape(scale,1,[])),...
                             reshape(pyramid_ref,1,[])./norm(reshape(pyramid_ref,1,[])));
                    end
                    if loss < min_loss
                        hor = i;
                        ver = j;
                        scl = scl * k;
                        min_loss = loss;
                        fprintf('Pyramid %d: \n\tShift_x: %f, shift_y: %f, scale: %f, loss: %f\n', pyramid_level, i, j, scl, loss);
                    end
                end
            end
        end
        
        hor_shift = hor_shift + hor * 2 ^ pyramid_level;
        ver_shift = ver_shift + ver * 2 ^ pyramid_level;
    end
    fprintf('shift: %f %f\n', hor_shift, ver_shift)
    aligned_img = circshift(img, [hor_shift, ver_shift]);
    mov_x = hor_shift;
    mov_y = ver_shift;
    return
end

            
        
        
if strcmp(method, 'ssd') | strcmp(method, 'ncc')
    disp(strcat('Using non-pyramid with \t',method))
    min_loss = inf;
    max_shift = 10;
    max_scale = 1.0;
    [h, w] = size(ref_img);
    for i=-max_shift:1:max_shift
        for j = -max_shift:1:max_shift
            for k = (2-max_scale):0.05:max_scale
                shift_img = circshift(img, [i j]);
                scale_img = imresize(shift_img, k, 'bilinear');
                if k >= 1
                    trans_img = scale_img(1:h, 1:w);
                else
                    trans_img = scale_img;
                    trans_img(h, w) = 0;
                end
                if strcmp(method, 'ssd')
                    loss = sum(sum((trans_img - ref_img).^2));
                else
                    loss = sum(dot(trans_img./norm(trans_img), ref_img./norm(ref_img)));
                end
                if loss < min_loss
                    min_loss = loss;
                    aligned_img = trans_img;
                end
            end
        end
    end
end
end
function loss=ssd(im1, im2)
    loss = sum(sum((im1 - im2).^2));
end                