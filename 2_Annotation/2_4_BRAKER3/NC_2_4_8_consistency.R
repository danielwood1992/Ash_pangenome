rm(list=ls())

file=read.csv("C:/Users/dwo11kg/LR_SR.PG2_4_4_10.2.results.txt.trimmed", sep = " ", header = T)

head(file)
hist(file$Total)
hist(file$LR)
hist(file$SR)
total = dim(file[file$Total == 20,])
total[1] #"These identified 32,207 genes annotated in every run"
SR_all_LR_none = dim(file[file$Total != 20 & file$SR == 10 & file$LR == 0,])
SR_all_LR_none #"with a further 1,519 genes annotated in every run of the short read annotation only"
LR_all_SR_none = dim(file[file$Total != 20 & file$SR == 0 & file$LR == 10,])
LR_all_SR_none #"and 1,392 genes annotated in every run of the long-read annotation only"

write.csv(LR_all_SR_none_names, "C:/Users/dwo11kg/LR_all_SR_none_names.Mar26.csv")
write.csv(SR_all_LR_none_names, "C:/Users/dwo11kg/SR_all_LR_none_names.Mar26.csv")

dim(file)[1]-total[1]-SR_all_LR_none[1]-LR_all_SR_none[1] #"A further 3,158 genes were inconsistently annotated, either in the short- or long-read runs"


