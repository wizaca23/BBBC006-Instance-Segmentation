pkg load image
clear

function a = softmax(n)
  a = exp(n)/sum(exp(n));
end

function new_img = apply_softmax(Y)
  
  new_img = zeros(size(Y));
  
  for i = 1:size(Y,1)
      for j = 1:size(Y,2)
            new_img(i,j,:) = softmax(Y(i,j,:));
      end
  end
  
end

function new_img = umbralizar(Y)
  [argvalue, argmax] = max(Y,[],3);
  new_img = zeros(size(Y));
  
  for i = 1:size(Y,1)
      for j = 1:size(Y,2)
          new_img(i,j,argmax(i,j)) = 255;
      end
  end
  
  new_img = new_img/255;
  
endfunction

kfolds = 5;
softmax = false;
  
for k=0:(kfolds - 1)
  
    %Input directory path
    path_input_a = strcat('/PATH/TO/FOLDS/-', strcat(num2str(k), '/'));
    imagefile_input = dir(strcat(path_input_a,'*.png'));
    
    %Number of files within the directory
    nfiles = length(imagefile_input);
    
    for i=1:nfiles
      
      %Loads every image WHAT ABOUT INT INSTEAD OF DOUBLE
      path_input = imagefile_input(i);
      path_total = strcat(path_input_a, path_input.name)
      
      input = double(imread(path_total));
      img = umbralizar(input);
      
      imwrite(img, path_total)
      
    endfor
    
endfor
