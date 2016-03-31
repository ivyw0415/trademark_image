function outN = wavF(n);
MAX = 1000000000;
inDB = 0;
rgb = imread(n);
I = rgb2gray(rgb);
grayI = medfilt2(I);
[gmag gdir]=imgradient(grayI,'prewitt');
I = uint8(gmag);
cA = 255-I;
cA(cA>200)=255;
cA(cA<=200)=0;

%wname = 'sym4';
wname = 'bior4.4';
feature = [];

%  feature derivation    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for a=1:2 %2-level wavelet transform
    %use function dwt2 to extract 4 directions' images
    [cA,cH,cV,cD] = dwt2(cA,wname);
    [M N] = size(cH);
    %calculate the convolution of result image with 
    %directional matrixes
    tempH = [1 0 1; 1 0 1; 1 0 1];
    h = conv2(cH,tempH);
    tempV = [1 1 1; 0 0 0; 1 1 1];
    v = conv2(cV,tempV);
    tempD1 = [0 0 1; 0 1 0;1 0 0];
    d1 = conv2(cD,tempD1);
    tempD2 = [1 0 0; 0 1 0; 0 0 1];
    d2 = conv2(cD,tempD2);

    p = [];
    q = [];
    p1 = [];
    q1 = [];
    dirH = 0;
    dirV = 0;
    dirD1 = 0;
    dirD2 = 0;

    for j = 1:M
        for k = 1:N
            h1 = abs(h(j,:));
            v1 = abs(v(:,k));
            d11 = abs(d1(j,:));
            d21 = abs(d2(:,k));
            pjk = abs(h(j,k))/sum(h1);
            p1jk = abs(d1(j,k))/sum(d11);
            qjk = abs(v(j,k))/sum(v1);
            q1jk = abs(d2(j,k))/sum(d21);
            p = [p pjk];
            q = [q qjk];
            p1 = [p1 p1jk];
            q1 = [q1 q1jk];
        end
    end

    for x=1:(M*N)
        dirH = dirH + p(x).^2;
        dirV = dirV + q(x).^2;
        dirD1 = dirD1 + p1(x).^2;
        dirD2 = dirD2 + q1(x).^2;
    end

    dirH = dirH./M./N;
    dirV = dirV./M./N;
    dirD1 = dirD1./M./N;
    dirD2 = dirD2./M./N;
    
    feature = [feature dirH dirV dirD1 dirD2];
end
%  end of feature derivation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
feature = (feature-min(feature))./(max(feature)-min(feature));
%  file read & write%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fidout1 = fopen('wavF.dat','r');
while ~feof(fidout1)
        rff = textscan(fidout1, '%s%f%f%f%f%f%f%f%f',1);
        inDB = strcmp(n, rff{1});
        if (inDB == 1)
            break;
        end
        inDB = 0;
end
fclose(fidout1);

if(inDB ~= 1)
    fidin = fopen('wavF.dat','a+');
    fprintf(fidin,'%s\t',n);
    for i = 1:8
        fprintf(fidin, '%f\t', feature(i));
    end
    fprintf(fidin,'\n');
    fclose(fidin);
end

l2=0;
outF = [MAX,MAX,MAX,MAX,MAX,MAX,MAX,MAX,MAX,MAX];
outN = {'string' 'string' 'string' 'string' 'string' 'string' 'string' 'string' 'string' 'string'};
fidout = fopen('wavF.dat','r');
while ~feof(fidout)
    rName = textscan(fidout, '%s',1);
    rFeature = textscan(fidout,'%f%f%f%f%f%f%f%f',1);
    for n = 1:8
        if n<5
            l2 = l2 + 0.25*(((feature(n)-rFeature{n}).^2));
        else
            l2 = l2 + (((feature(n)-rFeature{n}).^2));
        end
    end
    
    
    l2 = sqrt(l2);
    for i = 1:10
        if l2<outF(i) 
            for j=10:-1:i+1
                outF(j)=outF(j-1);
                outN(j)=outN(j-1);
            end
            outF(i)=l2;
            outN(i)=rName{1};
            break;
        end
    end
    l2=0;
end
fclose(fidout);

% figure();
% subplot(2,2,1);
% imshow(cA);
% subplot(2,2,2);
% imshow(cH);
% subplot(2,2,3);
% imshow(cV);
% subplot(2,2,4);
% imshow(cD);

 %show similar images%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure();
outN;
% subplot(1,8,1);
% imshow(outN{1});
% subplot(1,8,2);
% imshow(outN{2});
% subplot(1,8,3);
% imshow(outN{3});
% subplot(1,8,4);
% imshow(outN{4});
% subplot(1,8,5);
% imshow(outN{5});
% subplot(1,8,6);
% imshow(outN{6});
% subplot(1,8,7);
% imshow(outN{7});
% subplot(1,8,8);
% imshow(outN{8});