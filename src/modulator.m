function [f]=modulator( a, M )
if (M==1) % BPSK
   f=(2*a-1);
end
if (M==2) % QPSK
   a = reshape(a, 2,[]);
   b=a(1,:);
   c=a(2,:);
   f=((2*b-1)+1*1i*(2*c-1));
   f=f/sqrt(2);
end
if (M==4) % 16_QAM
   a = reshape(a,4,[]);
   b=a(1,:);
   c=a(2,:);
   d=a(3,:);
   e=a(4,:);
   z=2*d+e;
   y=2*b+c;
   f=((-4/3)*(y.^3)+5*(y.^2)-(5/3)*y-3)+1i*((-4/3)*(z.^3)+5*(z.^2)-(5/3)*z-3);
   f=f/sqrt(10);
end
if (M==6) % 64_QAM
   a = reshape(a,6,[]);
   b=a(1,:);
   c=a(2,:);
   d=a(3,:);
   e=a(4,:);
   g=a(5,:);
   h=a(6,:);
   x=4*b+2*c+d;
   y=4*e+2*g+h;
   f_real=-0.0508*x.^7+1.2667*x.^6-12.4556*x.^5+61.0833*x.^4-155.1556*x.^3+189.6500*x.^2-82.3381*x-7;
   f_imag=-0.0508*y.^7+1.2667*y.^6-12.4556*y.^5+61.0833*y.^4-155.1556*y.^3+189.6500*y.^2-82.3381*y-7;
   sz = size(f_real);
   for jj=1:sz(1,2)
       if (f_real(1,jj) >= 0.8504 && f_real(1,jj) <= 0.8506)
           f_real(1,jj) = 3;
       end
       if (f_imag(1,jj) >= 0.8504 && f_imag(1,jj) <= 0.8506)
           f_imag(1,jj) = 3;
       end
   end
   f=f_real+1i*f_imag;
   f=ceil(f);
   f=f/sqrt(42);
end