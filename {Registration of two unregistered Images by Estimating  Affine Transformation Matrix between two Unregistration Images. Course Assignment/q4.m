J1=imread("T1.jpg");
J2=imread("T2.jpg");

J1=double(J1);
J2=double(J2);

J3=imrotate(J2,28.5,'bilinear','crop');

[l2,w2]=size(J2);
[l3,w3]=size(J3);
m=ones(l3,w3);
m((l2+1):end,:)=0;
nccs=zeros(size(-45:45));
jes=zeros(size(-45:45));
qmis=zeros(size(-45:45));
ind=1;


for theta=-45:45
    J4 = imrotate(J3,theta,'bilinear','crop');
    J4=imresize(J4,size(J1));
    mean1=mean(J1(:));
    mean4=mean(J4(:));
    corr=sum((J1-mean1).*(J4-mean4),"all");
    var1=sum((J1-mean1).^2,"all");
    var4=sum((J4-mean4).^2,"all");
    ncc=corr/sqrt(var1*var4);
    nccs(ind)=ncc;

  
    jointhis=getJoint_Hist(J1,J4,10);
    probs=jointhis/sum(jointhis(:));
    joint_ent=-sum(probs(probs>0).*log(probs(probs>0)));
    jes(ind)=joint_ent;

    marg_his1=sum(probs,2);
    marg_his2=sum(probs,1);

    bins=ceil(256/10);
    QMI=0;
    for i=1:bins
        for j=1:bins
          QMI=QMI+(probs(i,j)-marg_his1(i)*marg_his2(j))^2;
        end
    end
    temp=marg_his2*marg_his1;
    QMI=QMI/temp(1,1);
    qmis(ind)=QMI;
     ind=ind+1;
end
thetas=-45:45;
figure(1);
subplot(3,1,1);
plot(thetas,nccs);
xlabel("Theta(degrees)");
ylabel("NCC");
title("NCC vs Angle plot");
subplot(3,1,2);
plot(thetas,jes);
xlabel("Theta(degrees)");
ylabel("Joint Entropy");
title("Joint Entropy vs Theta plot");
subplot(3,1,3)
plot(thetas,qmis);
xlabel("Theta(degrees)");
ylabel("QMI");
title("QMI vs Angle plot");


[minv,min_ind]=min(jes);
opt_theta=thetas(min_ind);
J4=imrotate(J3,opt_theta,'bilinear','crop');
joint_histogram=getJoint_Hist(J1,J4,10);
figure(2);
imagesc(joint_histogram);
colormap("turbo")

function jointhist=getJoint_Hist(I1,I2,binwidth)
    bins=ceil(256/binwidth);
    jointhist=zeros(bins,bins);
    for i = 1:numel(I1)
        b1=ceil(I1(i)/binwidth);
        b2=ceil(I2(i)/binwidth);
        b1=max(min(b1,bins),1);
        b2=max(min(b2,bins),1);

        jointhist(b1,b2)=jointhist(b1,b2)+1;
    end

    
end