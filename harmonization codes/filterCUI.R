
cuitab = read.delim("Part/CuiTermResult_Part.txt", sep='|', 
           stringsAsFactors = FALSE)

cuitab = cuitab[nchar(cuitab$Key)>3+1,]

semantic = c("disease or syndrome", "sign or symptom", 
              "neoplastic process", 
             "organ or tissue function", "pathologic function",
             #"finding",
             "therapeutic or preventive procedure", "diagnostic procedure", 
"laboratory procedure", "laboratory or test result", 
"pharmacologic substance", "biologically active substance", 
"hormone", "amino acid, peptide, or protein", "organic chemical")

cuitab = cuitab[grep(paste(semantic,collapse = '|'),
                     cuitab$Key.Semantictype),]

cuitab$ncui = sapply(cuitab$Key.Cui, function(x)
  lengths(regmatches(x, gregexpr(",", x))))
cuitab = cuitab[order(-cuitab$ncui),]

cuitab = cuitab[cuitab$ncui<=1,]

cuitab$minCui = sapply(cuitab$Key.Cui, function(x)
  min(as.integer(strsplit(gsub("C| |\\[|\\]", '',x),',')[[1]])))
x=cuitab$Key.Cui[1]
cuitab = cuitab[order(cuitab$minCui),]

cuidiag = cuitab[grep(paste(semantic[1:5],collapse = '|'),
                      cuitab$Key.Semantictype),]
keepdiag = sapply(cuidiag$Key.Semantictype, function(x)
  all(strsplit(gsub(" \\[ | \\] | $", '',x),' ; | / ')[[1]] %in% semantic[1:5]))
cuidiag = cuidiag[keepdiag,]
cuidiag = cuidiag[order(cuidiag$Key.Location),]

cuiproc = cuitab[grep(paste(semantic[6:7],collapse = '|'),
                      cuitab$Key.Semantictype),]
keepproc = sapply(cuiproc$Key.Semantictype, function(x)
  all(strsplit(gsub(" \\[ | \\] | $", '',x),' ; | / ')[[1]] %in% semantic[6:7]))
cuiproc = cuiproc[keepproc,]

cuimed = cuitab[grep(paste(semantic[-1:-7],collapse = '|'),
                     cuitab$Key.Semantictype),]
