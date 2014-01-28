function [msg,n] = DeCoder(code,h_freq,dectype,m,rate,bits_per_symb);
global ch ch1 puncture added
switch(dectype)
    case 'unquant'
        switch (m)
            case 0,
                msg = code;
                n = size(msg);
            case 1,
                switch (rate)
                    case 1,   % Rate is 1/2
                        t = poly2trellis([7],[133,171]);
                        p = [1,1,1;1,1,1];
                        add = 6;
                    case 2,   % Rate is 3/4
                        t = poly2trellis([7],[133,171]);
                        p = [1,1,0;1,0,1];
                        add = 6;
                    case 3,   % Rate is 2/3
                        t = poly2trellis([7],[133,171]);
                        p = [1,1;1,0]; 
                        add = 6;
                    case 4,
                        t = poly2trellis([9],[557,663,711]);
                        add = 10;
                end
                in = code;
                % p = reshape(p,1,size(p,1)*size(p,2));
                % li = ceil(size(in,2)/size(p,2));
                % p = repmat(p,1,li);
                % p = p(1:size(in,2));
                % puncture = p;
                % ch = 1:size(in,2);
                % ch = ch.*p;
                % ch1 = setdiff(1:size(in,2),ch);
                clear code;
                % size(ch,2)
                % size(in)
                % pause
                in = in(1:length(in)-added);
                in = in(1:size(find(ch),2));
%---------------------Блок DePunchuring-----------------%
                code(ch>0) = in;
                code(ch1) = 25;
%------------------------------------------------------%                
                % m = 1:(size(h_freq,2)*bits_per_symb);
                % h_freq2 = h_freq(ceil(m/bits_per_symb));
                % h_freq = h_freq2;
                h_freq = h_freq(1:length(h_freq)-added);
                h_freq = h_freq(1:size(find(ch),2));
                h_freq1(ch>0) = h_freq;
                h_freq1(ch1) = 1;
                opmode = 'term';
                tblen = 35;
                msg=viterdec(h_freq1,puncture,code,t,tblen,opmode,dectype);
                %msg = vitdec(code,t,tblen,opmode,dectype);
                msg = msg(1:size(msg,2)-add);
                n = size(msg);
        end   
end



