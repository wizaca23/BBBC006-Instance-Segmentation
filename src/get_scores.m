warning("off", "all")

kfolds = 5;

for k=0:(kfolds-1)
  
    printf("\nFold-%d starting\n", k)
  
    %Input directory path
    path_input_a = strcat('/PATH/TO/FOLDS/-', strcat(num2str(k), '/'))
    imagefile_input = dir(strcat(path_input_a,'*.png'));

    %Ground Truth directory path
    path_gt_a = '/PATH/TO/GT';
    
    %Number of files within the directory
    n_files = length(imagefile_input);
      
    A_precision = 0; A_recall = 0; A_f1 = 0; 
        
    for i=1:n_files
        
      % Obtains the i-th id and the image from it
      path_input = imagefile_input(i);
      input = double(imread(strcat(path_input_a, path_input.name)));
      gt = double(imread(strcat(path_gt_a, path_input.name)));
        
      # 1 if result is closer to 255, 0 otherwise
      input = (input > 0);
      gt = (gt > 0);
        
      TP_Matrix = input & gt;
      TP = sum(sum(TP_Matrix));
        
      FP_Matrix = (gt - input) > 0;
      FP = sum(sum(FP_Matrix));
       
      FN_Matrix = (input - gt) > 0;
      FN = sum(sum(FN_Matrix)); 

      epsilon = 0.0000001;
        
      precision = (TP+epsilon) ./ ((TP+FP) + epsilon); 
      recall = (TP+epsilon) ./ ((TP+FN) + epsilon);
        
      f1 = 2*((precision .* recall) ./ (precision + recall));
        
      A_precision = A_precision + precision; 
      A_recall = A_recall + recall; 
      A_f1 = A_f1 + f1; 
      
      if mod(i, 10) == 0
        printf("\nImages proccessed: [%d : %d]", i, n_files)
      endif
        
    endfor
        
    A_precision = A_precision ./ n_files;
    printf("\nFold-%d Avg Precision: R:%d G:%d B:%d", k, A_precision)
    
    A_recall = A_recall ./ n_files;
    printf("\nFold-%d Avg Recall: R:%d G:%d B:%d", k, A_recall)
    
    A_f1 = A_f1 ./ n_files;
    printf("\nFold-%d Avg F1 Score: R:%d G:%d B:%d", k, A_f1)
    
    %PMat((k+1), :) = reshape(A_precision, 1, 3);
    %PMat((k+1), :) = reshape(A_recall, 1, 3);
    %A_f1((k+1), :) = reshape(A_f1, 1, 3);
      
endfor