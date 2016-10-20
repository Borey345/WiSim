function testMimoThrougput()

nRx = 2;
nTx = 8;
H = complexRandn([nRx, nTx]);

x = [-1;1];

[U, LA, V] = svd(H);

xTx = V(:,1:nRx)*x;
y = LA(1:nRx, 1:nRx)\U'*H*xTx;


end

