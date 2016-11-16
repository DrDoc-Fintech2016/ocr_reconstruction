mydata = read.csv("example3.csv")
mydata[, 1]  <- as.numeric(mydata[, 1])
mydata[, 2]  <- as.numeric(mydata[, 2])
mydata[, 3]  <- as.numeric(mydata[, 3])
mydata[, 4]  <- as.numeric(mydata[, 4])
mydata[, 5]  <- as.numeric(mydata[, 5])
mydata[, 6]  <- as.numeric(mydata[, 6])
mydata[, 7]  <- as.numeric(mydata[, 7])
mydata[, 8]  <- as.numeric(mydata[, 8])

mydata$mean_x <- with(mydata, (x1 + x2)/2)
mydata$mean_y <- with(mydata, (y1 + y2)/2)


ggplot(mydata, aes(x= x1, y= -mean_y, label=extracted_text))+
  geom_point() +geom_text(aes(label=extracted_text),hjust=0, vjust=0)




