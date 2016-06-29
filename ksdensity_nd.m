function Phatfcn = ksdensity_nd(Xtrain, h, Kfcn)
% Xtrain [n x d] - training data
% h - bandwidth
% Kfcn - Kernel function (default: RBF) (alt example: @normpdf)
%
% returns:
%     Phatfcn - p-hat (if RBF: vectorized and evaluated in blocks)
% 
    if nargin < 2 || isnan(h)
        h = defaultBandwidth(Xtrain);
    end
    if nargin < 3
        doRBF = true;
    else
        doRBF = false;
    end
    
    if doRBF
        Phat = @(x) mean(RBFKernel(Xtrain, x, h));
        Phatfcn = blockEvalFcn(Phat, size(Xtrain,1));
        return;
    end

    % super slow version
    K = @(X,h) h^(-size(X,2))*Kfcn(sqrt(sum(X.^2, 2))/h);
    Phat = @(x) mean(K(bsxfun(@plus, Xtrain, -x), h));
    Phatfcn = unvectorizedFcn(Phat);

end

function h = defaultBandwidth(Xtrain)
    h = median(abs(bsxfun(@plus, Xtrain, -median(Xtrain)))) / 0.6745;
    h = median(h); % can't yet set bandwidth for each dimension
end

function fcn = unvectorizedFcn(Phat)
% unvectorized p-hat function
    fcn = @(Xtest) arrayfun(@(ii) Phat(Xtest(ii,:)), 1:size(Xtest,1));
end

function fcn = blockEvalFcn(Phat, nTrPts)
% vectorized p-hat function, evaluated in blocks
    fcn = @(Xtest) innerBlkEvalFcn(Phat, Xtest, nTrPts);
end

function P = innerBlkEvalFcn(Phat, pts, nTrPts)

    maxArrSize = 1e8;
    curArrSize = size(pts,1)*nTrPts;
    nbins = ceil(curArrSize/maxArrSize);
    if nbins == 1
        P = Phat(pts)';
        return;
    end
    
    P = nan(size(pts,1),1);
    bins = round(linspace(1, size(pts,1), nbins));
    for ii = 1:nbins-1
        inds = bins(ii):bins(ii+1);
        if ii < nbins-1
            inds = inds(1:end-1);
        end
        P(inds) = Phat(pts(inds,:));
    end

end
