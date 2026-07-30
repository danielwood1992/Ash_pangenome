rm(list=ls())
library(ggplot2)


file = read.csv("C:/Users/dwo11kg/complete_merged_PG2_12_2.all_types.all_types.tags.3.vcf.repeat_overlap.summary", sep = "\t", header = F)

head(file)
table(file$V1)

file$V1 <- factor(file$V1, levels = c("genome", "all", "INS", "DEL", "INV", "DUP"), labels = c("genome_wide", "all_SVs", "INS", "DEL", "INV", "DUP"))

#write.csv(file, "C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/Documents/PG_Submission_010825/PG_Resubmission_0326/Revision_Documents/Plot_Data/FigS5.2.csv")


safe_colorblind_palette <- c("#88CCEE", "#CC6677", "#DDCC77", "#117733", "#332288", "#AA4499", 
                             "#44AA99", "#999933", "#882255", "#661100", "#6699CC")




plot = ggplot(file, aes(x = V2, y = V4, fill = V1)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = safe_colorblind_palette) +  # apply your palette
  labs(x = "Repeat Type", y = "Percentage of total base pairs (%)", fill = NULL) +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 11, 
                              family = "Arial", 
                              color = "black"),
    axis.text = element_text(size = 10, 
                             family = "Arial", 
                             color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1))
plot

ggsave("~/NC_R3_FigureS8.png", plot, width = 200, height = 200, units = "mm", dpi = 600)
