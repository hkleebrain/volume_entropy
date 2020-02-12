# Volume entropy

Author: Hyekyoung Lee 
Date: February 12, 2020 

This is based on a toy example in the paper 
'Volume entropy for modeling information flow in a brain graph' (Lee, et. al, Scientific Reports, 2019 ([https://www.nature.com/articles/s41598-018-36339-7](https://www.nature.com/articles/s41598-018-36339-7))).


```Matlab
% Given network 
L = [0 1 1 2 0 0 0; ... 
    1 0 2 1 0 0 0; ... 
    1 2 0 1 3 0 0; ... 
    2 1 1 0 0 3 4; ... 
    0 0 3 0 0 1 1; ... 
    0 0 0 3 1 0 1; ... 
    0 0 0 4 1 1 0]; 
p = size(L,1); 


% Volume entropy 
Lnorm = L/sum(sum(L))*2;
[h,edge_capacity,node_capacity] = volume_entropy(Lnorm);


% Plot the network 
pts = [10 20; 10 10; 20 20; 20 10; 50 20; 50 10; 58.66 15]; 
node_color = [255 0 0; 70 126 178; 125 186 103; 231 147 21; 162 131 179; 124 189 185; 150 106 50]/255; 

figure; 
subplot(2,2,1), 
node_size = 2*ones(p,1);
draw_directed_graph(pts,L,node_color,node_size); 
title('Given network'); 
subplot(2,2,2), 
draw_directed_graph(pts,edge_capacity); 
title('Information flow with node capacity');  
subplot(2,2,3), 
node_size = min(sum(edge_capacity)*10/3,3.999);
draw_directed_graph(pts,edge_capacity,repmat([1 0 0],[p 1]),node_size); 
title('Information flow with afferent node capacity');  
subplot(2,2,4), 
node_size = min(sum(edge_capacity')*10/3,3.999);
draw_directed_graph(pts,edge_capacity,repmat([0 0 1],[p 1]),node_size); 
title('Information flow with efferent node capacity');  
```

![network](https://user-images.githubusercontent.com/54297018/74328747-ce211680-4dd1-11ea-91a5-55aa7887c4b4.jpg)


