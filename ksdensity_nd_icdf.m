function icdf = ksdensity_nd_icdf(Phatfcn, xs)

    ysh = Phatfcn(xs');
    if abs(trapz(xs, ysh)-1) > 1e-3
        error('cdf is incomplete. need a bigger input range');
    end
    icdf = @(pts) xs(get_ixs(ysh, pts));
    
end

function ixs = get_ixs(ysh, pts)

    F = cumsum(ysh)/max(cumsum(ysh));
    errs = bsxfun(@plus, F, -pts).^2;
    [~,ixs] = min(errs, [], 2);

end
