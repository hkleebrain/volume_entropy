function draw_directed_graph(pts,dist,node_color,node_size)
% pts: p*2 points
% dist: p*p asymmetric distance matrix, from-by-to
% node_size: p*1 vector, size of nodes
% node_color: p*3 vector, color of node
% 
% Copyright (c) 2020, Hyekyoung Lee (hklee.brain@gmail.com)
% All rights reserved.


p = size(pts,1);

if size(pts,2) == 2,
    pts = [pts zeros(p,1)];
end

% symmetric test
issym = issymmetric(dist);

if ~issym,
    if nargin < 3,
        node_capacity = sum(dist) - sum(dist');
        node_color = zeros(p,3);
        tind = find(node_capacity < 0); % negative
        node_color(tind,:) = repmat([0 0 1],[length(tind) 1]);
        tind = find(node_capacity >= 0); % negative
        node_color(tind,:) = repmat([1 0 0],[length(tind) 1]);
        
        node_size = abs(node_capacity)*10;
        udist = [];
        for i = 1:p,
            for j = i+1:p,
                udist = [udist sqrt(sum((pts(i,:)-pts(j,:)).^2))];
            end
        end
        node_size = min(node_size,min(udist)/2*0.8);
    end
    
    margin = 0.86; % min(node_size)*0.8;
    for i = 1:p,
        for j = 1:p,
            if dist(i,j) ~= 0,
                x0 = pts(i,1); y0 = pts(i,2); z0 = pts(i,3);
                x1 = pts(j,1); y1 = pts(j,2); z1 = pts(j,3);
                dx = x1 - x0; dy = y1 - y0; dz = z1 - z0;
                leng = sqrt(dx.^2+dy.^2+dz.^2);
                if i < j,
                    quiver3(x0+margin,y0+margin,z0,dx,dy,dz,(leng-node_size(j))/leng,'LineWidth',ceil(dist(i,j)*10),'Color','k');
                else
                    quiver3(x0-margin,y0-margin,z0,dx,dy,dz,(leng-node_size(j))/leng,'LineWidth',ceil(dist(i,j)*10),'Color','k');
                end
                hold on;
            end
        end
    end
    
else
    for i = 1:p,
        for j = i+1:p,
            if dist(i,j) ~= 0,
                x0 = pts(i,1); y0 = pts(i,2); z0 = pts(i,3);
                x1 = pts(j,1); y1 = pts(j,2); z1 = pts(j,3);
                line([x0 x1],[y0 y1],[z0 z1],'LineWidth',1,'Color','k');
                hold on;
            end
        end
    end
end


for i = 1:p,
    [x{i},y{i},z{i}] = ellipsoid(pts(i,1),pts(i,2),pts(i,3),node_size(i),node_size(i),node_size(i));
    surf(x{i}, y{i}, z{i},'EdgeColor','none','FaceColor',node_color(i,:));
end
view(0,90);

