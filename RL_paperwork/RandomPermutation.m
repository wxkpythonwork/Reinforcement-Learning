function y=RandomPermutation(A) %因为A中其实不存在所有1到r*c的元素值，所以要去里面随机的一个，不能用randperm来取

   [r,c]=size(A);
   b=reshape(A,r*c,1);       % 转换为列向量
   x=randperm(r*c);          
   w=[b,x'];                 % x'为x的转置
   d=sortrows(w,2);          % 按第二列排序
   y=reshape(d(:,1),r,c);   