function out = Coder_Wi_Fi( in )
trellis = poly2trellis(7,[133,171]);
out = convenc( in, trellis, 0 );
% global ch ch1 puncture    
% switch (n)
%     case 0,
%         y = msg;
%         N = size(msg,2);
%     case 1,
%         switch (rate)
%             case 1,   % Rate is 1/2
%                 t = poly2trellis(7,[133,171]);
%                 p = [1,1,1;1,1,1];
%                 add = 6;
%             case 2,   % Rate is 3/4
%                 t = poly2trellis(7,[133,171]);
%                 p = [1,1,0;1,0,1];
%                 add = 6;
%             case 3,   % Rate is 2/3
%                 t = poly2trellis(7,[133,171]);
%                 p = [1,1;1,0]; 
%                 add = 6;
%             case 4,
%                 t = poly2trellis(9,[557,663,711]);
%                 add = 10;
%         end
%         msg((size(msg,2)+1):(size(msg,2)+add)) = 0;
%         in = convenc(msg,t,0);
%         N = size(in,2);
%---------------------Áëîê Punchuring-----------------%
%         p = reshape(p,1,size(p,1)*size(p,2));
%         li = ceil(size(in,2)/size(p,2));
%         p = repmat(p,1,li);
%         p = p(1:size(in,2));
%         puncture = p;
%         ch = 1:size(in,2);
%         ch = ch.*p;
%         ch1 = setdiff(1:size(in,2),ch);
%------------------------------------------------------%
%         y = in(ch>0);
end


