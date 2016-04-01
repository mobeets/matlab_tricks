%% init data

N = 100;
d = 3;
mu = randi(5, [1 d]);
Sig = randCovariance(d);
X = mvnrnd(mu, Sig, N);

%% define p-hat

[phatfcn, phatfcn2] = ksdensity_nd(X);

%% evaluate at grid of points

d = size(X,2);
nbins = 50;
mn = min(X); mx = max(X);
grd = cell(d,1);
for ii = 1:d
    grd{ii} = linspace(mn(ii), mx(ii), nbins);
end
pts = cell(1,numel(grd));
[pts{:}] = ndgrid(grd{:});
pts = cell2mat(cellfun(@(p) p(:), pts, 'uni', 0));

%%

P = phatfcn2(pts);

%% plot - 3d

prcThresh = 95;
prc = prctile(P, [prcThresh prcThresh+1]);
ix = P >= prc(1) & P <= prc(2);

figure; set(gcf, 'color', 'w');
hold on; set(gca, 'FontSize', 14);

% plot3(X(:,1), X(:,2), X(:,3), 'k.');
plot3(pts(ix,1), pts(ix,2), pts(ix,3), '.', 'Color', [0.8 0.2 0.2]);
x = reshape(pts(:,1), nbins, nbins, nbins);
y = reshape(pts(:,2), nbins, nbins, nbins);
z = reshape(pts(:,3), nbins, nbins, nbins);
v = reshape(P, nbins, nbins, nbins);
% patch(isosurface(x, y, z, v, prc(1)));


%% plot - 2d

mn = min(X); mx = max(X);
[xx,yy] = meshgrid(linspace(mn(1), mx(1)), linspace(mn(2), mx(2)));
Y = [xx(:) yy(:)];
P = phatfcn([xx(:) yy(:)]);

prc = prctile(P, [25 50 75]);
ix = P >= prc(3);

figure; set(gcf, 'color', 'w');
hold on; set(gca, 'FontSize', 14);

plot(X(:,1), X(:,2), 'ko');
plot3(Y(~ix,1), Y(~ix,2), P(~ix), '.', 'Color', [0.2 0.2 0.8]);
plot3(Y(ix,1), Y(ix,2), P(ix), '.', 'Color', [0.8 0.2 0.2]);

