require(plyr)

#整理需要载入文件的url

uci_har_dataset<-"UCI HAR Dataset"
feature_file <- paste(uci_har_dataset, "/features.txt", sep = "")
activity_labels_file <- paste(uci_har_dataset, "/activity_labels.txt", sep = "")
x_train_file <- paste(uci_har_dataset, "/train/X_train.txt", sep = "")
y_train_file <- paste(uci_har_dataset, "/train/y_train.txt", sep = "")
subject_train_file <- paste(uci_har_dataset, "/train/subject_train.txt", sep = "")
x_test_file  <- paste(uci_har_dataset, "/test/X_test.txt", sep = "")
y_test_file  <- paste(uci_har_dataset, "/test/y_test.txt", sep = "")
subject_test_file <- paste(uci_har_dataset, "/test/subject_test.txt", sep = "")

#开始读取数据

features <- read.table(feature_file, colClasses = c("character"))
activity_labels <- read.table(activity_labels_file, col.names = c("ActivityId", "Activity"))
x_train <- read.table(x_train_file)
y_train <- read.table(y_train_file)
subject_train <- read.table(subject_train_file)
x_test <- read.table(x_test_file)
y_test <- read.table(y_test_file)
subject_test <- read.table(subject_test_file)

#将收集到的数据合成为一个数据集

training_sensor_data <- cbind(cbind(x_train, subject_train), y_train)
test_sensor_data <- cbind(cbind(x_test, subject_test), y_test)
sensor_data <- rbind(training_sensor_data, test_sensor_data)

#将添加了Subject和ActivityId后整个的数据表名重新命名给sensor_data

sensor_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(sensor_data) <- sensor_labels

#用正则表达式匹配sensor_data中含有mean,std,subject,acticityid的列，其实就是选出平均值和标准差

sensor_data_mean_std <- sensor_data[,grepl("mean|std|Subject|ActivityId", names(sensor_data))]

#将筛选出来的表格的列进行重新排列

sensor_data_mean_std <- join(sensor_data_mean_std, activity_labels, by = "ActivityId", match = "first")
sensor_data_mean_std <- sensor_data_mean_std[,-1]

#用替换的方法将原来features文件中的测试项目的命名进行修改使其更加可读。

names(sensor_data_mean_std) <- gsub('\\(|\\)',"",names(sensor_data_mean_std), perl = TRUE)
names(sensor_data_mean_std) <- gsub('Acc',"Acceleration",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Gyro',"AngularSpeed",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Mag',"Magnitude",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('^t',"TimeDomain.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('^f',"FrequencyDomain.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('\\.mean',".Mean",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('\\.std',".StandardDeviation",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Freq\\.',"Frequency.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Freq$',"Frequency",names(sensor_data_mean_std))

#最终将表格输出

sensor_final_data = ddply(sensor_data_mean_std, c("Subject","Activity"), numcolwise(mean))
write.table(sensor_final_data, file = "sensor_final_data.txt")