function aligned_img = align(img, ref_img, method, pyramid)
if nargin == 2
    method = 'ssd';
    pyramid = 0;
end
if nargin == 3
    pyramid = 0;
end
if pyramid ~= 0
    fprintf('Using pyramid factor: %f, method: %s\n',pyramid, method)
    hor_shift = 0;
    ver_shift = 0;
    [h, w] = size(ref_img);
    first_max_shift = 5;
    ver=0;
    hor=0;
    for pyramid_level=pyramid:-1:0
        % Global shift
        min_loss = inf;
        shifited_img = circshift(img, [hor_shift, ver_shift]);
        resize_factor = (1/2)^pyramid_level;
        pyramid_img = imresize(shifited_img, resize_factor);
        pyramid_img = edge(pyramid_img, 'log');
        pyramid_ref = imresize(ref_img, resize_factor);
        pyramid_ref = edge(pyramid_ref, 'log');
        if pyramid_level == pyramid
            max_shift = first_max_shift;
        else
            %if max(abs(hor_shift), abs(ver_shift)) ~= 0
            max_shift = ceil((max([abs(hor), abs(ver), 1]) * 2));
            %max_shift = 5
        end
        for i=-max_shift:max_shift
            for j=-max_shift:max_shift
                shift = circshift(pyramid_img, [i, j]);
                if strcmp(method, 'ssd')
                    loss = sum(sum((shift - pyramid_ref).^2));
                else
                    loss = dot(reshape(shift,1,[])./norm(reshape(shift,1,[])),...
                         reshape(pyramid_ref,1,[])./norm(reshape(pyramid_ref,1,[])));
                end
                if loss < min_loss
                    hor = i;
                    ver = j;
                    min_loss = loss;
                end
            end
        end
        hor_shift = hor_shift + hor * 2 ^ pyramid_level;
        ver_shift = ver_shift + ver * 2 ^ pyramid_level;
    end
    fprintf('shift: %f %f\n', hor_shift, ver_shift)
    aligned_img = circshift(img, [hor_shift, ver_shift]);
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
                