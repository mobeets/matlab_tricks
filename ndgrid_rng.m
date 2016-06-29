function pts = ndgrid_rng(X, nbins)
    if nargin < 2
        nbins = 100;
    end
    
    d = size(X,2);
    mn = min(X); mx = max(X);
    grd = cell(d,1);
    for ii = 1:d
        grd{ii} = linspace(mn(ii), mx(ii), nbins);
    end
    pts = cell(1,numel(grd));
    [pts{:}] = ndgrid(grd{:});
    pts = cell2mat(cellfun(@(p) p(:), pts, 'uni', 0));
end
