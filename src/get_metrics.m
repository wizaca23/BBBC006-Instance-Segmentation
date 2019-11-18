pkg load image
metrics;
clear

warning("off", "all")

% enable - disable for the desire calculation
compute_ABDE = true;
compute_AGCE = false;
compute_ADice = true;

% Defines k of kfolds applied and the size of each partition %
kfolds = 5;

for k=0:(kfolds - 1)
  
    %Input directory path
    path_input_a = strcat('/PATH/TO/FOLDS/-', strcat(num2str(k), '/'))
    imagefile_input = dir(strcat(path_input_a,'*.png'));

    %Ground Truth directory path
    path_gt_a = '/PATH/TO/GT';

    %Number of files within the directory
    n_files = length(imagefile_input);

    %Average Border Displacement Error
    ABDE = 0;

    %Average Global Consistency Error
    AGCE = 0;
    
    %Average Multi-Class Weighted Dice Loss
    ADice = 0;
    
    out = 0;
    
    if(compute_ABDE)
    
      for i=1:n_files
        
        % Obtains the i-th id and the image from it
        path_input = imagefile_input(i);
        
        input = double(imread(strcat(path_input_a, path_input.name)));
        gt = double(imread(strcat(path_gt_a, path_input.name)));
        
        input = input/255;
        gt = gt/255;

        %result_red = compare_image_boundary_error(input(:,:,1),gt(:,:,1));
        %result_green = compare_image_boundary_error(input(:,:,2),gt(:,:,2));
        result_blue = compare_image_boundary_error(input(:,:,3),gt(:,:,3));

        %BDE = (result_red * 0.3) + (result_green * 0.3) + (result_blue * 0.4);
        BDE = result_blue;

        ABDE = ABDE + BDE;
        
        if mod(i, 10) == 0
          printf("\nBDE: [%d : %d]", i, n_files)
        endif

      end

      BDE(k+1) = ABDE / n_files;
      printf("\nAverage BDE: %d", BDE(k+1))

    end

    if(compute_AGCE)
      
      for i=1:n_files
        
        % Obtains the i-th id and the image from it
        path_input = imagefile_input(i);
        
        input = double(imread(strcat(path_input_a, '\', path_input.name)));
        gt = double(imread(strcat(path_gt_a,'\', path_input.name)));

        result_red = GlobalConsistencyError(input(:,:,1),gt(:,:,1));
        result_green = GlobalConsistencyError(input(:,:,2),gt(:,:,2));
        result_blue = GlobalConsistencyError(input(:,:,3),gt(:,:,3));

        GCE = (result_red * 1/3) + (result_green * 1/3) + (result_blue * 1/3);

        AGCE = AGCE + GCE;
        
        if mod(i, 10) == 0
          printf("\nGCE: [%d : %d]", i, n_files)
        endif

      end

      GCE(k+1) = AGCE / n_files;
      printf("\nAverage GCE: %d", GCE(k+1));

    end
    
    if(compute_ADice)

      nan_results = 0;

      for i=1:n_files
        
        % Obtains the i-th id and the image from it
        path_input = imagefile_input(i);
        
        input = double(imread(strcat(path_input_a, path_input.name)));
        gt = double(imread(strcat(path_gt_a, path_input.name)));

        Local_Dice = dice_multi(input, gt);

        if(isnan(Local_Dice))
          nan_results = nan_results + 1;
        else
          ADice = ADice + Local_Dice;
        end
        
        if mod(i, 10) == 0
          printf("\nWDMC: [%d : %d]", i, n_files)
        endif
      
      end

      Dice(k+1) = ADice / (n_files-nan_results);
      printf("\nAverage WDMC: %d", Dice(k+1))

  end
 
endfor






