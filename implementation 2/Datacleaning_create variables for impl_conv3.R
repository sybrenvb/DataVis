library(dplyr)
library(rjson)
library(ggplot2)
library(tidyr)
#Import dataset
BOM <- read.csv("~/schoolwerk/hoger/Master of statistics and data science/1e Master/Data visualisation/Suncharge data/BOM.csv")
MaterialPlantRelation <- read.csv("~/schoolwerk/hoger/Master of statistics and data science/1e Master/Data visualisation/Suncharge data/MaterialPlantRelation.csv")
Purchases <- read.csv("~/schoolwerk/hoger/Master of statistics and data science/1e Master/Data visualisation/Suncharge data/Purchases.csv")
Materials <- read.csv("~/schoolwerk/hoger/Master of statistics and data science/1e Master/Data visualisation/Suncharge data/Materials.csv")
#glyphs
##select all raw materials
raw_materials <- MaterialPlantRelation %>%
  filter(MaterialKey >= 3) %>%
  select(MaterialKey, PlantKey, VendorKey,
         ProductionTime, InboundTransportationTime, GoodReceiptProcessingTime) %>%
  mutate(production_time = ProductionTime,
         inbound_transportation_time= ProductionTime + InboundTransportationTime,
         good_receipt_processing_time = ProductionTime + InboundTransportationTime + GoodReceiptProcessingTime)
raw_materials_plant1 <- raw_materials %>%
  filter(PlantKey == 1)
raw_materials_plant2 <- raw_materials %>%
  filter(PlantKey == 2)
raw_materials_plant3 <- raw_materials %>%
  filter(PlantKey == 3)
##add information: of which finished product is the semifinished product part
merged_df <- merge(BOM, Materials, by = "Material", all.x = TRUE)
MaterialProductrelation <- merged_df %>%
  select(MaterialKey, Finished.Product)%>%
  filter(MaterialKey>=3)
##merge the MaterialProductrelation with the raw_materials
timesplant1 <- merge(MaterialProductrelation, raw_materials_plant1, by = "MaterialKey", all.x = TRUE)%>%
  pivot_longer(cols = c(production_time, inbound_transportation_time, good_receipt_processing_time), names_to = "time_type", values_to = "value")
timesplant2 <- merge(MaterialProductrelation, raw_materials_plant2, by = "MaterialKey", all.x = TRUE)%>%
  pivot_longer(cols = c(production_time, inbound_transportation_time, good_receipt_processing_time), names_to = "time_type", values_to = "value")
timesplant3 <- merge(MaterialProductrelation, raw_materials_plant3, by = "MaterialKey", all.x = TRUE)%>%
  pivot_longer(cols = c(production_time, inbound_transportation_time, good_receipt_processing_time), names_to = "time_type", values_to = "value")
#plots
plant1_plot <- ggplot(timesplant1, aes(x = MaterialKey, y = value, 
                                              color = time_type)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ Finished.Product) +
  scale_x_continuous(breaks = seq(min(3), max(33), by = 1)) +
  ggtitle("Time Types for Different Materials ProductionPlant 1") +
  xlab("Semi-finished Material") +
  ylab("Number of days") +
  theme_minimal()
plant2_plot <- ggplot(timesplant2, aes(x = MaterialKey, y = value, 
                                       color = time_type)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ Finished.Product) +
  scale_x_continuous(breaks = seq(min(3), max(33), by = 1)) +
  ggtitle("Time Types for Different Materials ProductionPlant 2") +
  xlab("Semi-finished Material") +
  ylab("Number of days") +
  theme_minimal()
plant3_plot <- ggplot(timesplant3, aes(x = MaterialKey, y = value, 
                                       color = time_type)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ Finished.Product) +
  scale_x_continuous(breaks = seq(min(3), max(33), by = 1)) +
  ggtitle("Time Types for Different Materials ProductionPlant 3") +
  xlab("Semi-finished Material") +
  ylab("Number of days") +
  theme_minimal()
print(plant1_plot)
print(plant2_plot)
print(plant3_plot)

#interactive data
Purchases$date1 = as.Date(Purchases$PlannedArrivalDateYard, type = "%Y-%m-%d")
Purchases$date2 = as.Date(Purchases$ActualArrivalDateYard, type = "%Y-%m-%d")
Purchases$DaysTooLate = Purchases$date2 - Purchases$date1
int_data = Purchases[ ,c("PlantKey","MaterialKey", "PurchaseOrderQuantity", "ActualArrivalDateYard", "DaysTooLate")]
View(int_data)
int_data <- int_data %>%
  arrange(PlantKey, MaterialKey)
write.csv(int_data, "interactive2.csv", row.names = FALSE)
myfile=toJSON(int_data)
write(myfile, "myJSON.json")
 
