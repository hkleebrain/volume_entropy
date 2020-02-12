function [h,edge_capacity,node_capacity] = volume_entropy(L)
% Find h that satisfies the maximum eigenvalue of e^{-hL} = 1.
% Input
% L : p * p distance matrix (p is the number of nodes) 
% Output 
% h : volume entropy 
% edge_capacity: p * p asymmetric matrix obtained by eigenvector (from row to
% column) 
% node_capacity: p*1 vector  
% 
% References 
% @article{lim.2008.tams,
%     author = "Seonhee Lim",
%     title = "Minimal volume entropy on graphs",
%     journal = "Trans. Amer. Math. Soc.",
%     volume = "360",
%     year = "2008",
%     pages = "5089--5100",
% }
% @article{lee.2018.arxiv, 
%     title = "Volume entropy and information flow in a brain graph", 
%     author = "Hyekyoung Lee and Eunkyung Kim and Hyejin Kang and Youngmin Huh and Youngjo Lee and Seonhee Lim and Dong Soo Lee", 
%     url = "https://arxiv.org/abs/1801.09257", 
%     pages = "arXiv:1801.09257", 
%     year = "2018"
% } 
% Copyright (c) 2018, Hyekyoung Lee (hklee.brain@gmail.com)
% All rights reserved.


eps = 10^(-13);
p = size(L,1); 
L = L.*~eye(p); 
% Normalize to two
L = L/sum(sum(L))*2; 

% [T,ind] = edge_matrix(L); 
% q = size(T,1); 
% [row,col] = find(T);
% val = nonzeros(T); 
[row,col,val,q,ind] = edge_matrix(L); 

h1 = 1; 
h2 = 0.5; 
[U,lambda1] = eigs(sparse(row,col,exp(-h1*val),q,q),1);  
[U,lambda2] = eigs(sparse(row,col,exp(-h2*val),q,q),1);  


while abs(lambda1 - lambda2) > 10^(-30), 
    if lambda1 > 1 & lambda2 > 1,  
        h3 = h2 - (lambda2 - 1)*(h1-h2)/(lambda1 - lambda2); 
        [U,lambda3] = eigs(sparse(row,col,exp(-h3*val),q,q),1);  
        
        h1 = h2; lambda1 = lambda2; 
        h2 = h3; lambda2 = lambda3; 
    elseif lambda1 > 1 & lambda2 < 1, 
        h3 = h2 + (lambda2 - 1)*(h2-h1)/(lambda1 - lambda2); 
        [U,lambda3] = eigs(sparse(row,col,exp(-h3*val),q,q),1);  
        
        if lambda3 < 1, 
            h2 = h3; lambda2 = lambda3;
        else
            h1 = h3; lambda1 = lambda3; 
        end 
    else 
        h3 = h1 - (lambda1 - 1)*(h2-h1)/(lambda2 - lambda1); 
        [U,lambda3] = eigs(sparse(row,col,exp(-h3*val),q,q),1);  
        
        h1 = h2; lambda1 = lambda2;
        h1 = h3; lambda1 = lambda3; 
    end
    
    if abs(lambda1-1) < eps,
        h = h1; mev = lambda1; 
        break; 
    elseif abs(lambda2-1) < eps,
        h = h2; mev = lambda2; 
        break;
    end
    display(num2str([lambda1 lambda2])); 
end
h = h1; 
mev = lambda1; 
x = U; 

tind = find(ind>0); 
[tval,ttind] = sort(ind(tind),'ascend'); 
mtxx = zeros(size(ind)); 
mtxx(tind(ttind)) = abs(x);
% mtxx(tind(ttind)) = x;
edge_capacity = mtxx; 
node_capacity = sum(edge_capacity) - sum(edge_capacity'); 

function [row,col,val,q,ind] = edge_matrix(L)
% L : p * p distance matrix (p : number of nodes), 
% T : q * q edge matrix (q = p*(p-1) number of oriented edges);

p = size(L,1); 
L = L.*(L>0);  

ind = []; 
count = 1; 
for i = 1:p,
    for j = 1:p, 
        if i ~= j & L(j,i) ~= 0,  
            ind(j,i) = count;  % column first 
            count = count + 1; 
        end 
    end 
end
    
q = max(max(ind)); 
row = []; col = []; val = []; 
for i = 1:p, 
    for j = 1:p, 
        if i ~= j & L(j,i) ~= 0, 
            next_ind = find(L(i,[1:p]) > 0);
            next_ind = setdiff(next_ind,[j]);
            
            row = [row repmat(ind(j,i),[1 length(next_ind)])]; 
            col = [col ind(i,next_ind)]; 
            val = [val L(i,next_ind)]; 
            % T(ind(j,i),ind(i,next_ind)) = L(i,next_ind); 
            display(num2str([i j])); 
        end
    end 
end 
