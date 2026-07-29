  #Arranging multiple panels from different R scripts...
  rm(list=ls())
  library(grid)
  library(gridExtra)
  library(png)
  

  load("~/PG2_PlotS3_INS.RData")
  load("~/PG2_PlotS3_DEL.RData")
  load("~/PG2_PlotS3_INV.RData")
  load("~/PG2_PlotS3_DUP.RData")
  

  plot = arrangeGrob(PG2_PlotS3_INS, PG2_PlotS3_DEL, PG2_PlotS3_INV, PG2_PlotS3_DUP, nrow = 2, ncol = 2)
  plot(plot)
  ggsave("C:/Users/dwo11kg/OneDrive - The Royal Botanic Gardens, Kew/PG_SupFig3.png", plot, width = 250, height = 200, units = "mm", dpi = 600)
  
  