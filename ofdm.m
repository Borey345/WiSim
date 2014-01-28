nbits       = 1024;             % Size of information sequence.
N           = 1;                % Number of antenn
Modulation  = 1;                % Type of modulation: 1-PBSK,2-QPSK,4-16_QAM,6-64_QAM.
nRealiz     = 1;                % The number of realizations in statistical ensemble.
coderRate        = 1;                % Темп кодирования: 1 - 1/2; 2 - 3/4; 3 - 2/3.
n           = 0;                % Флаг включения кодера: 1 - кодер включен; 0 - кодер выключен.
m           = 0;                % Флаг включения декодера Витерби: 1 - декодер включен; 0 - декодер выключен.
dectype     = 'unquant';        % Декодер Витерби с мягкими метриками.
added       = 0;                % Для OFDM - систем added не ноль

fd          = 100 ;             % Max Dopler Frequency
Timp        = 100*10^(-6);      % Time of impuls
L           = 10000;            % Length
type        = 1;
%-------------------------------------------------------------------------%
ii        = 0;
consol = waitbar(0,'Please wait...');
SNR = zeros( 16, 1 );
for snr = -10 : 2 : 20                                % in dB
    P       = 1*10^(snr/10);                          % The power of signal (variance of noise is 1)
    ii      = ii + 1;
    SNR(ii) = snr;
    k=0;
    for jj = 1 : nRealiz
         % a       = double(randn(1, Modulation*nbits) > 0);
        a = randi( [0 1], 1, Modulation*nbits );% input an information sequence
        a_coder = Coder_Wi_Fi( a, coderRate, n );                   % action of coder
        d = mapper( a_coder, Modulation );         % action of mapper
%       for q=1 : nbits 
%         for k=1: nbits-1
%              s  = d*(exp((-j)*2*pi*q*k/nbits))*1/sqrt(nbits);
%              k1(g) = k1(g) + s;
%         end
%       end  
        h = ( randn( N, size( d,2 ) )+1j*randn( N,size( d,2 ) ) )./sqrt(2);   %Релеевский канал
%         
%           w=conj(h);
%           b=h.*w;
%           c=b;
       
        for g=1 : nbits 
            lp=0;
                for l=1 : nbits
                    s= h(l).*d(g)*(exp((-1i)*2*pi*g*l/nbits))*1/sqrt(nbits);
                    lp = lp+ s;
                end 
            l1(g)=lp;
        end
        
        noise   = 1*(randn(N,size(d,2)) + 1i*randn(N,size(d,2)))/sqrt(2);
%         noise=(w.*noise);
      
        for g=1 : nbits 
              qp=0;
         for q=1: nbits
            z= noise(q)*(exp((-1i)*2*pi*g*q/nbits))*1/sqrt(nbits);
            qp = qp+ z;   
         end 
        q1(g)=qp;
        end  
        
        x = l1 + q1;
        
        
        out     = demapper(x,Modulation);       % action of demapper
        mm      = 1:(size(h,2)*Modulation);     % Это punchuring для канальных коэффициентов
        h_2     = h(ceil(mm/Modulation));
      h    = h_2;
        [out_decoder,Num] = DeCoder(out,abs(h),dectype,m,coderRate,Modulation);      % action of decoder
        ber(jj) = mean(out_decoder(1:Modulation*nbits)~=a(1:Modulation*nbits)); % ber meter
    end
    mean_ber(ii) = mean(ber);
    consol = waitbar(ii/20);
% % figure(1);                                               % practice plots
% semilogy(SNR,mean_ber,'.r');
% axis ([-20 20 10^(-4) 1]);
% title('BER in system with N received antens');
% xlabel('SNR, dB');
% ylabel('BER');
% grid on;
% hold on;
end
close(consol);
%-------------------------------------------------------------------------%
figure;                                               % practice plots
semilogy(SNR,mean_ber);
axis ([-20 20 10^(-4) 1]);
title('BER in OFDM system ');
xlabel('SNR, dB');
ylabel('BER');
grid on;
hold on;
 

