%% Using SeDuMi/MOSEK solver for Lyapunov Equation. (Matriculation number = A0201459J)
clear
close all
clc

% Define the problem parameters.
n = 100; % Dimension of the system matrix. (Change for sections 4.1 and 4.3)
A = randi([-3,3],n,n); % System matrix (Random).
Q = eye(n); % Given matrix.

% Define the constraint parameters.
m = 2; % Dimension of the constraints. (Change for section 4.2)
s = 0; % Counter for addition of constraints.
k = 2; % Constraint value (positive).

% Define the tolerance parameters.
e = 2.22e-16; % Machine precision.
tol = [e^0.25; e^0.5; e^(7/8)]; % Reduced tolerance, and Standard & Solver tolerances. (Change for section 4.4)

% Solve the Lyapunov equation using SeDuMi solver with CVX.
cvx_precision (tol)
cvx_begin 
    cvx_solver sedumi % Change the solver type: sedumi OR mosek.
    variable P(n,n) semidefinite symmetric
    minimize(trace(P)) % Minimize trace of solution matrix P.
    subject to
        P*A + A'*P + Q <= 0; % Lyapunov Function (LMI in variable P).
        for i = 1:m
            s = s + P(i,i);
            s <= k; % Inequality constraint.
        end
cvx_end

size_A = whos('A').bytes;
size_Q = whos('Q').bytes;
[user, sys] = memory; % Available memory after optimization. 
mem_used = user.MemUsedMATLAB - (size_A + size_Q);

% Display the memory used for optimization process.
disp('Memory used (bytes) = ');
disp(mem_used);

% Display the solution.
disp('Solution P = ');
disp(P);

% Display the solver tolerance.
disp('Solver, Standard, Reduced tolerances: ')
disp(cvx_precision);

%% Extra redundant variables.
% A = [-1 -2 -3; 0 -1 -2; 0 0 -1]; % System matrix.
% P(1,1) + P(2,2) + P(3,3) == 2; % 3-dimensional constraint. 