# 
# install deps
# 
packages <- c("jsonlite", "plyr", "ggrepel", "psych", "stringi", "devtools")
packages <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})

#
# install updated ggmap library
# 
library(devtools)
install_github("dkahle/ggmap")
library(ggmap)

# 
# set working directory
# 
setwd("/Volumes/bb3/_works/2016-expedition-through-dc/research")
#install.packages("jsonlite")
#library(jsonlite)

# load cods with coords
cods <- fromJSON("./data/moscow_cods_with_coords.json", flatten=TRUE)
# colnames(cods)

# load metro stations
metros <- fromJSON("./data/metro_stations.json", flatten=TRUE)
# head(metros$stations)
# length(metros$stations)
#summary($station)

v <- metros$stations
v$line <- metros$line
summary((v[[1]]))
summary(v$line)


colnames(metros$stations[[1]])

options(stringsAsFactors=TRUE)
# ?lapply
# ?flatten
# ?mapply
# ?data.frame
# ?do.call
# ?rep
# rep(1:4, 2)

# mm <- flatten(data.frame(metros$stations))
# colnames(mm)


v <- mapply(function (x, y) data.frame(line=rep(x, length(y$station)),
                                       station=y$station,
                                       lat=as.numeric(y$lat),
                                       lon=as.numeric(y$lon)),
       metros$line,
       metros$stations,
       SIMPLIFY=FALSE,
       USE.NAMES = FALSE)

colnames(v)

metro_stations <- Reduce(function(x, y) merge(x, y, all=TRUE), v)
summary(metro_stations)
is.list(v)


# ?Reduce
# ?merge
# 
# ?lapply
?get_map

head(v)
head(cods)
summary(cods)
# moscow coords
map =  get_map(location = c(lon = 37.618423, lat = 55.751244), zoom = 12, source="google")
ggmap(map)

cods <- subset(cods, !is.na(coords.latitude))

cod_coords <- cods[, 6:7]
cod_coords$count <- 1
cod_coords <- rename(cod_coords, c("coords.latitude"="lat", "coords.longitude"="lon"))
cod_coords <- subset(cod_coords, !is.na(lat))


k <- kmeans(cod_coords, 20)

cods$cluster <- factor(k$cluster)
centers <- as.data.frame(k$centers)
centers$num <- c(1:length(centers$lon))


# ?subset
# ?geom_point
# ?aes
# ?ggmap
# ?geom_text_repel
# ?get_map
# ?geom_text_repel

# ?get_openstreetmap

#
# plot interesting cods
#
interesting_cods <- subset(cods, cluster==5)
loc <- subset(centers, num==5)
#
map1 =  get_map(location = c(lon=loc$lon, lat=loc$lat),
                zoom = 13,
                source="google",
                color="bw")                
#
# map1 =  get_map(location = "метро Октябрьское поле",
#                 zoom = 14,
#                 source="osm",
#                 color="bw")
#
# ggmap(map1) + geom_point(data = interesting_cods,
#                         aes(x = coords.longitude, y = coords.latitude, color = cluster),
#                         size = 2,
#                         alpha = .7) +
#   #geom_text_repel(data=interesting_cods, aes(x = coords.longitude, y = coords.latitude, label = name, color=cluster)) +  
#   geom_text_repel(data=interesting_cods, aes(x = coords.longitude, y = coords.latitude, label = address, color=cluster)) +    
#   geom_point(data=centers, aes(x = lon, y = lat, color=as.character(num), label=as.character(num)), size=10, alpha=.5) +
#   geom_text_repel(data=centers, aes(x = lon, y = lat, color=as.character(num), label=as.character(num), color="black")) +    
#   geom_point(data=centers, aes(x = lon, y = lat, color=as.character(num)), size=60, alpha=.3) +
#   geom_point(data = metro_stations,
#              aes(x=as.numeric(lon), y=as.numeric(lat), color=line),
#              size=2,
#              alpha = 0.9) +
#   geom_text_repel(data=metro_stations, 
#                   aes(x=as.numeric(lon), y=as.numeric(lat), color = line, label = station),
#                   alpha=0.9) +  
#   scale_size_area(max_size = 2) + 
#   labs(y = NULL, x = NULL) +
#   theme(axis.text = element_blank(), 
#         axis.ticks = element_blank(),
#         legend.position = "none")



#
# plot all cods with clusters
#
# ggmap(map) + geom_point(data = cods,
#                         aes(x = coords.longitude, y = coords.latitude, color = cluster),
#                         size = 2,
#                         alpha = .7) +
#   geom_text_repel(data=cods, aes(x = coords.longitude, y = coords.latitude, label = name, color=cluster)) +  
#   geom_point(data=centers, aes(x = lon, y = lat, color=as.character(num), label=as.character(num)), size=10, alpha=.5) +
#   geom_text_repel(data=centers, aes(x = lon, y = lat, color=as.character(num), label=as.character(num), color="black")) +    
#   geom_point(data=centers, aes(x = lon, y = lat, color=as.character(num)), size=60, alpha=.3) +
#   geom_point(data = metro_stations,
#              aes(x=as.numeric(lon), y=as.numeric(lat), color=line),
#              size=2,
#              alpha = 0.9) +
#   geom_text_repel(data=metro_stations, 
#                   aes(x=as.numeric(lon), y=as.numeric(lat), color = line, label = station),
#                   alpha=0.9) +  
#   scale_size_area(max_size = 2) + 
#   labs(y = NULL, x = NULL) +
#   theme(axis.text = element_blank(), 
#         axis.ticks = element_blank(),
#         legend.position = "none")

#
# plot cods with metro stations
#
# ggmap(map1) + geom_point(data = cods,
#                         aes(x = coords.longitude, y = coords.latitude, color = NULL, size = 0.5),
#                         alpha = .9) +
#   geom_text_repel(data=cods, aes(x = coords.longitude, y = coords.latitude, label = name)) +
#   geom_point(data = metro_stations,
#              aes(x=as.numeric(lon), y=as.numeric(lat), color = "red", size=2),
#              alpha = 0.5) +
#   geom_text_repel(data=metro_stations, aes(x=as.numeric(lon), y=as.numeric(lat), color = "red", label = station)) +
#   scale_size_area(max_size = 2) + 
#   labs(y = NULL, x = NULL) +
#   theme(axis.text = element_blank(), 
#         axis.ticks = element_blank(),
#         legend.position = "none")