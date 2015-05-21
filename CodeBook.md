#主要步骤
1.  整合培训和测试集，创建一个数据集。

2.  仅提取测量的平均值以及每次测量的标准差。

3.  使用描述性活动名称命名数据集中的活动

4.  使用描述性变量名称恰当标记数据集。

5.  从第4步的数据集中，针对每个活动和每个主题使用每个表里的平均值建立第2个独立的整洁数据集。

#变量描述

features feature.txt文件中的各测试数据的名称
activity_labels 测试项目的名称
x_train x_train_file内容
y_train y_train_file内容
subject_train subject_train_file内容
x_test x_test_file内容
y_test y_test_file内容
subject_test subject_test_file内容
training_sensor_data 训练集数据
test_sensor_data 测试集数据
sensor_data 总数据
sensor_labels 最终数据的列名
sensor_data_mean_std 抽取的mean和std的数值
sensor_final_data 整理列名后的数据