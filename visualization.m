% 定义函数表达式和约束条件
f = @(x1, x2) x1.^4 - 2*x2.*x1.^2 + x2.^2 + x1.^2 - 2*x1 + 5;
constraint = @(x1, x2) -(x1 + 0.25).^2 + 0.75*x2;

% 创建网格点以生成图像
x1 = linspace(-3, 3, 10);
x2 = linspace(-10, 10, 10);
[X1, X2] = meshgrid(x1, x2);
Z = f(X1, X2);
 

% 绘制3D图像
figure;
surf(X1, X2, Z, 'FaceAlpha', 0.7); % 函数图像
hold on;
 
xlabel('x1');
ylabel('x2');
zlabel('f(x)');
 
 

% 
% 添加约束线
x1_vals = linspace(-3, 3, 100);
x2_vals = 0.75*(x1_vals + 0.25).^2;
plot3(x1_vals, x2_vals, constraint(x1_vals, x2_vals), 'r', 'LineWidth', 2);
% 添加图例
legend('f(x)', 'Constraint');
grid on;
hold off;
