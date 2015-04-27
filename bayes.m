load fisheriris    % 把文件fisheriris.mat中数据导入MATLAB工作空间

head0 = {'Obj', 'x1', 'x2', 'x3', 'x4', 'Class'};  % 设置表头
[head0; num2cell([[1:150]', meas]), species]   % 以元胞数组形式查看数据

% 用meas和species作为训练样本，创建一个朴素贝叶斯分类器对象ObjBayes
ObjBayes = NaiveBayes.fit(meas, species);
% 利用所创建的朴素贝叶斯分类器对象对训练样本进行判别，返回判别结果pre0，pre0也是字符串元胞向量
pre0 = ObjBayes.predict(meas);
% 利用confusionmat函数，并根据species和pre0创建混淆矩阵（包含总的分类信息的矩阵）
[CLMat, order] = confusionmat(species, pre0);
% 以元胞数组形式查看混淆矩阵
[[{'From/To'},order'];order, num2cell(CLMat)]

% 查看误判样品编号
gindex1 = grp2idx(pre0);  % 根据分组变量pre0生成一个索引向量gindex1
gindex2 = grp2idx(species);  % 根据分组变量species生成一个索引向量gindex2
errid = find(gindex1 ~= gindex2)  % 通过对比两个索引向量，返回误判样品的观测序号向量

% 查看误判样品的误判情况
head1 = {'Obj', 'From', 'To'};  % 设置表头
% 用num2cell函数将误判样品的观测序号向量errid转为元胞向量，然后以元胞数组形式查看误判结果
[head1; num2cell(errid), species(errid), pre0(errid)]

% 对未知类别样品进行判别
% 定义未判样品观测值矩阵x
x = [5.8	2.7	1.8	0.73
    5.6		3.1	3.8	1.8
    6.1		2.5	4.7	1.1
    6.1		2.6	5.7	1.9
    5.1		3.1	6.5	0.62
    5.8		3.7	3.9	0.13
    5.7		2.7	1.1	0.12
    6.4		3.2	2.4	1.6
    6.7		3	1.9	1.1
    6.8		3.5	7.9	1
    ];
% 利用所创建的朴素贝叶斯分类器对象对未判样品进行判别，返回判别结果pre1，pre1也是字符串元胞向量
pre1 = ObjBayes.predict(x)