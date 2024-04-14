A = [-18 16 8; -29 27 13; 10 -10 -4];
B = [ 1 ; -3 ; -2];

%find the pole of open loop, stable?

eig(A)

% 6, -2, 1, two RHP pole, not stable


%controlable?


R_b = ctrb(A,B);

rank(R_b)

% rank 3 = full rank the system is completely controlable

% Feedback gains

poles = [-2,-19,-38];
K = place(A,B,poles);

% K = [18 -18 4]

% Verify stability

A_new = A - B*K;

eig(A_new);

% -38, -2, -19 , all LHR poles, so it is stable