image_folder = 'input';
image_out_folder = 'output';
filenames = dir(fullfile(image_folder, '*.jpg')); 
total_images = numel(filenames);    
for n = 1:total_images
    file_name = imread(fullfile(image_folder, filenames(n).name));
    
    cform = makecform('srgb2lab');
    rgb2labspace = applycform(file_name, cform);

    lab_color_space_image = double(rgb2labspace(:,:,2:3));
    nrows = size(lab_color_space_image,1);
    ncols = size(lab_color_space_image,2);
    lab_color_space_image = reshape(lab_color_space_image,nrows*ncols,2);

    specify_required_colors = 2;
    n_iterations = 3;
    [cluster_idx, cluster_center] = kmeans(lab_color_space_image,specify_required_colors,'distance','sqEuclidean', 'Replicates',n_iterations);

    pixel_labels = reshape(cluster_idx,nrows,ncols);

    segmented_images = cell(1,2);
    rgb_label = repmat(pixel_labels,[1 1 3]);

    for k = 1:specify_required_colors
        color = file_name;
        color(rgb_label ~= k) = 255;
        segmented_images{k} = color;
    end
    
    figure(1), 
    subplot(2,2,1);
    imshow(file_name), title('Original Image');
    subplot(2,2,2);
    imshow(segmented_images{2},[]), title('Cluster 1');
    subplot(2,2,3);
    imshow(segmented_images{1},[]), title('Cluster 2');
    %imwrite(segmented_images{2}, strcat(image_out_folder, filenames(n).name));
    %imwrite(segmented_images{1}, strcat(image_out_folder, filenames(n).name));
end