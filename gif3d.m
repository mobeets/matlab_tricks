
N = 1000; p = 3;
X = zeros(N,p);
z1 = randn(N,1);
z2 = randn(N,1);
X(:,1) = 8*z1;
X(:,2) = 2*z2;
X(:,3) = -4*z2;

figure; set(gcf, 'color', 'w'); hold on;
plot3(X(:,1), X(:,2), X(:,3), '.'); xlabel('x'); ylabel('y'); zlabel('z');

grid on;
clear im;

az = -15; el = 30;
view([az,el]);

f = getframe;
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,1) = 0;
xl = xlim; yl = ylim; zl = zlim;

for ii = 1:30
    azc = az - ii;
    view([azc, el + ii])
    f = getframe;
    imc = rgb2ind(f.cdata,map,'nodither');
    im(:,:,1,ii) = imc;
    %   if isequal(size(imc), size(squeeze(im(:,:,1,1))))
    %       im(:,:,1,k+1) = imc;
    %   else
    %       warning(num2str([azc el]))
    %   end

    [azc el]
    xlim(xl); ylim(yl); zlim(zl);
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    set(gca, 'ZTickLabel', []);
    set(gca, 'XTick', linspace(xl(1), xl(2), 5));
    set(gca, 'YTick', linspace(yl(1), yl(2), 5));
    set(gca, 'ZTick', linspace(zl(1), zl(2), 5));
end
imwrite(im, map, 'Animation.gif', 'DelayTime', 0.05, 'LoopCount', inf)

