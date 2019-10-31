library(readxl)
library(tidyverse)

# read data from Excel file
df <- read_xlsx("HEAT Baltic by Basin.xlsx",sheet="Sheet1")

basins<-c("KA","DS","AB","BN","BP","GR","GF","BS","BB")
names(df)<-c("Year",basins)

# KA=Kattegat
# DS=Danish_Straits
# AB=Arkona_Basin
# BN=Bornholm_Basin
# BP=Baltic_Proper
# GR=Gulf_of_Riga
# GF=Gulf_of_Finland
# BS=Bothnian_Sea
# BB=Bothnian_Bay

# transpose data from 'wide' format to 'long' format
df <- df %>% gather(key="Basin",value="cat",2:10)


df$cat <- factor(df$cat)
df$cat <- factor(as.character(df$cat),
                     levels=rev(levels(df$cat)))

df$Basin <- factor(df$Basin,levels=basins)
df$Year <- factor(df$Year)


# define colour palette
pal<-c("#FF2121","#FAB70E","#FFFF00","#8FFF07","#2C96F6","#FFFFFF")

textcol <- "grey40"

fig<-ggplot(df, aes(Basin, Year,fill = cat)) +
  geom_tile(show.legend=FALSE) +
  scale_y_discrete(expand=c(0,0),
                 breaks=c("2020","2010","2000","1990","1980","1970","1960","1950","1940","1930","1920","1910","1900"))+
  scale_fill_manual(values=pal,na.value="#FFFFFF")+
  labs(x="",y="",title="")+ 
  theme_minimal(base_size=4)+
  theme(
    plot.margin = unit(c(0,2,5,0), "pt"),
    axis.text.x=element_text(size=3,colour="#000000"),
    axis.text.y=element_text(vjust = 0.2,colour="#000000"),
    axis.ticks.y=element_line(size=0.2,colour=textcol),
    axis.ticks.x=element_blank(),
    plot.background=element_blank(),
    panel.border=element_blank())   
fig

# save figure as png
ggsave(fig,filename="figure.png",width=3,height=6,units="cm",dpi=300)
