function outN = snyF(imageNM)
MAX = 1000000000;
inDB = 0;
rgb = imread(imageNM);
image=rgb;
I = rgb2gray(image);
grayI = medfilt2(I);
Ibw = edge(grayI,'canny',0.05);


[px,py]=find(Ibw==1);
centerX = mean(px);
centerY = mean(py);


mDis=0;
m=size(px);
for i=1:m    
    disTemp=sqrt((px(i)-centerX).^2+(py(i)-centerY).^2);
    if disTemp>mDis
       mDis=disTemp;
       x=px(i);
       y=py(i);
    end
end

[newX,newY]=size(Ibw);
rect=[ceil(centerY-mDis),ceil(centerX-mDis),ceil(mDis+centerX),ceil(mDis+centerY)];
queryI=imcrop(Ibw,rect);
qI = imresize(queryI,[100,100]);
queryI=imresize(queryI,[200,200]);
[px py]=find(qI>0);
vv=[px py];
v=[];
curvF=0;
[Xout,Yout]=points2contour(px,py,1,'cw');
NN=size(Xout);
for i=1:NN(2)
    v=[v;Xout(i) Yout(i)];
end
k=LineCurvature2D(v);
curvF=std(k);

%global feature zernike moments
glbF=[];
n = [0  1  1  2  2  2  3  3  3  3  4  4  4  4  4];
m = [0 -1  1 -2  0  2 -3 -1  1  3 -4 -2  0  2  4];
for i=1:15
    [Z, A, Phi] = Zernikmoment(queryI,n(i),m(i));
    glbF=[glbF,A];
end
%glbF=(glbF-min(glbF))./(max(glbF)-min(glbF));
glbF = glbF./(max(glbF)+min(glbF));

%local feature distance
[X, Y]=find(Ibw);
X=X-centerX; Y=Y-centerY;
rho = sqrt(X.^2+Y.^2);
rScale = 100./mDis;
rho = rho*rScale;
meanD=mean(rho);
stdD=std2(rho);
dd=[meanD,stdD];
dd=dd./(max(dd)+min(dd));
lclF = [curvF,dd];
lclF=lclF./(max(lclF)+min(lclF));

% histo=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
% countH=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
% for i=1:size(rho)
%     for j=1:20
%         if rho(i)<=(j*5)&&rho(i)>(j-1)*5
%             histo(j)=histo(j)+1;
%             countH(j)=countH(j)+rho(i);
%         end
%     end
% end
% for i=1:20
%      countH(i)=countH(i)/histo(i);
% end
% interval=[5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100];
% plot(interval,histo,'-x')
% xlabel('distance to centroid','FontSize',20,'FontWeight','bold');
% ylabel('occurance','FontSize',20,'FontWeight','bold');


%file read & write
fidout1 = fopen('synF.dat','r');
while ~feof(fidout1)
        rff = textscan(fidout1, '%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',1);
        inDB = strcmp(imageNM, rff{1});
        if (inDB == 1)
            break;
        end
        inDB = 0;
end
fclose(fidout1);

if(inDB ~= 1)
    fidin1 = fopen('synF.dat','a+');
    fprintf(fidin1,'%s\t',imageNM);
    for i = 1:15
        fprintf(fidin1, '%f\t', glbF(i));
    end
    for i = 1:3
        fprintf(fidin1, '%f\t', lclF(i));
    end
    fprintf(fidin1,'\n');
    fclose(fidin1);
end

gl=0;
ll=0;
euDis=0;
outF = [MAX,MAX,MAX,MAX,MAX,MAX,MAX,MAX,MAX,MAX];
outN = {'string' 'string' 'string' 'string' 'string' 'string' 'string' 'string' 'string' 'string'};
fidout = fopen('synF.dat','r');
while ~feof(fidout)
    rName = textscan(fidout, '%s',1);
    feature = textscan(fidout,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',1);
    for n = 1:18
        if n<16
            gl = gl + ((glbF(n)-feature{n}).^2);
        else
            ll = ll + ((lclF(n-15)-feature{n}).^2);
        end
    end
    
    gl = sqrt(gl);
    ll = sqrt(ll);
    if gl>0.3
        euDis=gl+1;
    else
        euDis=gl;
    end
    if ll>0.3
        euDis=euDis+ll+1;
    else
        euDis=euDis+ll;
    end
    for i = 1:10
        if euDis<outF(i) 
            for j=10:-1:i+1
                outF(j)=outF(j-1);
                outN(j)=outN(j-1);
            end
            outF(i)=euDis;
            outN(i)=rName{1};
            break;
        end
    end
    gl=0;
    ll=0;
    euDis=0;
end
fclose(fidout);

outN;
