function y=RandomPermutation(A) %��ΪA����ʵ����������1��r*c��Ԫ��ֵ������Ҫȥ���������һ����������randperm��ȡ

   [r,c]=size(A);
   b=reshape(A,r*c,1);       % ת��Ϊ������
   x=randperm(r*c);          
   w=[b,x'];                 % x'Ϊx��ת��
   d=sortrows(w,2);          % ���ڶ�������
   y=reshape(d(:,1),r,c);   