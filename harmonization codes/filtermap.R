
map = read.csv("Part/OriginalData_Part.csv",
               stringsAsFactors = FALSE)

# map$des=paste0(' ',map$des,' ')
# map$term = paste0(' ',map$term,' ')
# map = map[-grep("excl",map$type),]

filter = rep(TRUE,nrow(map))
for(i in 1:nrow(map))
{
  lowdes = map$des[i]
  try(lowdes <- tolower(lowdes) )
  filter[i] = !all(is.na(grep(tolower(map$term[i]),
                              lowdes)))
}

table(filter)
map = map[filter,]

map = map[order(-map$score),]
map = map[!duplicated(map[,c("code","cui","type")]),]
map = map[map$score>=0.4,]
map = map[order(map$Superior.Key.Location, -map$Superior.Key.Location2,
                -map$score),]

mapdiag = map[map$cui%in%
                unlist(strsplit(gsub(" |\\[|\\]", '',cuidiag$Key.Cui),',')),]

mapdiag = mapdiag[!mapdiag$cui %in% 
                    c("C1306459","C0027651","C0856825",
                      "C0595961", "C0867389","C0006826"),]

mapproc = map[map$cui%in%
                unlist(strsplit(gsub(" |\\[|\\]", '',cuiproc$Key.Cui),',')),]

write.csv(map, file = "C:/Users/hou00123/OneDrive - Harvard University/REST Project/paper2-big picture/use case/FilterData3.csv",
          row.names = FALSE)
