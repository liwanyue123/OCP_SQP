syms x1 x2 lambda real;

%% 符号公式计算

% 目标函数
f = f_func([x1,x2]);
d_f=jacobian(f, [x1, x2])';
dd_f= hessian(f, [x1, x2])';

% 约束函数
c = constrain_func([x1,x2]);
d_c=jacobian(c, [x1, x2])';
dd_c= hessian(c, [x1, x2])';

% 拉格朗日函数
L = f + lambda * c;
% 计算拉格朗日函数二阶偏导数
dd_L = dd_f+lambda *dd_c;

%% 数值计算

%初始猜想
x_init=[0;-2];
x_k=x_init;
lambda_k =1;
x1=x_init(1);
x2=x_init(2);




max_iter=50;
tol=0.001;
k=0;
while k < max_iter

    var(1).name = 'x1';
    var(1).value = x1;
    var(2).name = 'x2';
    var(2).value = x2;
    var(3).name = 'lambda';
    var(3).value = lambda_k;

    cost=calFunc(f,var) %查看目标函数的值


    %代入数据
    f_val=calFunc(f,var);
    d_f_val=calFunc(d_f,var);
    dd_f_val=calFunc(dd_f,var);
    c_val=calFunc(c,var);
    d_c_val=calFunc(d_c,var);
    dd_c_val=calFunc(dd_c,var);
    L_val=calFunc(L,var);
    dd_L_val=calFunc(dd_L,var);
    %  min 0.5 x^T H x+f^T x
    %  A x <= b
    %  Aeq x =beq
    %  lb <= x <= ub
    [delta_x,fval,exitflag,output,lambda] = quadprog(dd_L_val,d_f_val,d_c_val',-c_val,[], [], [], [],x_init);
    %  x =quadprog(H,f,A,b,Aeq,beq,lb,ub,x0)

    % 更新当前估计值
    x_k = x_k + delta_x
    x1=x_k(1);
    x2=x_k(2);
    lambda_k = lambda.ineqlin;

    


    % 检查收敛
    if norm(delta_x) < tol
        disp("find!!!!!")
        break;
    end

    k = k + 1;
end

function result =  calFunc(symFunc, variables)
    % symFunc：要求值的符号函数
    % variables：一个结构体，包含变量名和对应的值

    % 创建符号变量
%     syms(symFunc); 

    % 将变量赋值
    for i = 1:numel(variables)
        var_name = variables(i).name;
        var_value = variables(i).value;
        eval([var_name, ' = ', num2str(var_value), ';']);
    end

    % 计算符号函数的值
    result = eval(symFunc);
end

function c = constrain_func(x)
x1=x(1);
x2=x(2);
c = -(x1 + 0.25)^2 + 0.75*x2;
end

function y = f_func(x)
x1=x(1);
x2=x(2);
y=x1^4 - 2*x2*x1^2 + x2^2 + x1^2 - 2*x1 + 5;
end
