
dat =read.csv("data/paper surg/CRC_surg_20210514_features_v2.csv",
              stringsAsFactors = F)
dat.LACcum =read.csv("data/analysis/CRC_surg_20210507_LACcum.csv",
                     stringsAsFactors = F)
dat.CPT = read.csv("data/paper surg/CRC_surg_CPT.csv", 
                   stringsAsFactors = F)
LAC.gen = "C44204"
OC.gen = "C44140"
LAC.right = "C44205"
OC.right = "C44160"
LAC.sigmoid = c("C44207", "C44208")
OC.sigmoid = c("C44145", "C44146")
CPT.comon = c(LAC.gen, OC.gen, LAC.right, OC.right, 
              LAC.sigmoid, OC.sigmoid)
dat$LAC.cum = dat.LACcum$LAC.cum[match(dat$patientNum, dat.LACcum$patientNum)]
dat$OC.CPT = dat.CPT$open.filtered.code[match(dat$patientNum, dat.CPT$patientNum)]
dat$LAC.CPT = dat.CPT$lap.filtered.code[match(dat$patientNum, dat.CPT$patientNum)]
dat$CPT = dat$OC.CPT
dat$CPT[dat$lap.CPT.filtered] = dat$LAC.CPT[dat$lap.CPT.filtered]


date.var = c("birth_date","death_date","last.date","trt_date", "first_CRC_dx")
for (tmpvar in date.var)
{
  dat[,tmpvar] =as.Date(dat[,tmpvar])
}
dat = dat[(dat$trt_date <= as.Date("2017-12-31"))&
            (dat$trt_date >= as.Date("2006-01-01")),]
dat = dat[as.numeric(dat$last.date - dat$trt_date, units = "days")>30, 
          ]

gap = as.numeric(dat$trt_date - dat$first_CRC_dx, units = "days")
table( gap>=0 & gap <= 90)
dat = dat[gap>=0 & gap <= 90, ]

dat.rct = read.csv(paste(local.path,"Merck/RCT data/NCT00002575-Colectomy/master.csv", sep=''),
                   stringsAsFactors = F)
dat.rct = dat.rct[!is.na(dat.rct$fu_yrs),]
dat.rct = dat.rct[dat.rct$stage!=4,]
dat.rct = dat.rct[!is.na(dat.rct$bow_adh),]

# Apply some eligibility criteria
dat = dat[as.numeric(format(dat$trt_date, "%Y")) %in% 2006:2017, ]

table(dat$crohn_new,dat$lap.CPT.filtered) # 43
dat = dat[!dat$crohn_new,] # Crohn's disease rare 14,10
table(dat$cuc_new,dat$lap.CPT.filtered) # 40
dat = dat[!dat$cuc_new,] # rare 5,1
table(dat$CRC_seg_surgday,dat$lap.CPT.filtered)
dat = dat[!(dat$CRC_seg_surgday %in% c("multiple", "rectum","unknown","transverse colon")), ] # rare in LAC 4,9
table(dat$CRC_seg_surgday, dat$CPT)
table(!(dat$CPT %in% CPT.comon),dat$lap.CPT.filtered)
dat = dat[dat$CPT %in% CPT.comon ,]
table((dat$CRC_seg_surgday=="Right" & 
       dat$CPT %in% c(OC.sigmoid, LAC.sigmoid))
    | (dat$CRC_seg_surgday=="sigmoid" & 
         dat$CPT %in% c(OC.right, LAC.right))
    | (dat$CRC_seg_surgday=="Left" & 
         dat$CPT %in% c(OC.sigmoid, LAC.sigmoid,
                        OC.right, LAC.right)),
    dat$lap.CPT.filtered)
dat = dat[!(dat$CRC_seg_surgday=="Right" & 
              dat$CPT %in% c(OC.sigmoid, LAC.sigmoid)), ]
dat = dat[!(dat$CRC_seg_surgday=="sigmoid" & 
              dat$CPT %in% c(OC.right, LAC.right)), ]
dat = dat[!(dat$CRC_seg_surgday=="Left" & 
              dat$CPT %in% c(OC.sigmoid, LAC.sigmoid,
                             OC.right, LAC.right)), ]
table(dat$obstruct_new, dat$lap.CPT.filtered) # 537
dat = dat[!dat$obstruct_new,] # rare in LAC 13
table(dat$stage.wICD, dat$lap.CPT.filtered)
dat = dat[-which(dat$stage.wICD==4),]
sum(is.na(dat$stage.wICD))
dat = dat[!is.na(dat$stage.wICD),]
table(dat$prior_cancer_new, dat$lap.CPT.filtered)
dat = dat[!dat$prior_cancer_new,]

table(dat$adhesion, dat$lap.CPT.filtered)
adhesion = as.numeric(dat$adhesion_new)
seg = factor(dat$CRC_seg_surgday, levels =  c("Right", "Left", "sigmoid"))
right.gen = as.numeric(dat$CRC_seg_surgday=="Right" & 
                         dat$CPT %in% c(OC.gen, LAC.gen))
sigmoid.gen = as.numeric(dat$CRC_seg_surgday=="sigmoid" & 
                         dat$CPT %in% c(OC.gen, LAC.gen))
trt = as.numeric(dat$lap.CPT.filtered)
stage = factor(dat$stage.wICD, levels = c(0:3),
               exclude = NULL,
               labels = c("0-1","0-1",2:3)) # Merge O-I, O rare, 2,0

library(survival)
library(ggplot2)
surv.rct = Surv(dat.rct$fu_yrs, dat.rct$FU_STAT-1)
trt.rct = as.numeric(dat.rct$arm=='B')

# dat$death_date[which(dat$death_date > as.Date("2019-12-31"))] = as.Date(NA)
# dat$last.date = pmin(dat$last.date, as.Date("2019-12-31"))
death = !is.na(dat$death_date)
sojourn = as.numeric( dat$last.date - dat$trt_date, units = "days")/365.2425
sojourn[death] =  as.numeric( dat$death_date[death] - dat$trt_date[death], units = "days")/365.2425
surv = Surv(sojourn, death)
trt = as.numeric(dat$lap.CPT.filtered)

ltfu = is.na(dat$death_date) & (dat$last.date <= as.Date("2019-12-31"))
dat$last.date = pmin(dat$last.date, as.Date("2019-12-31"))
sojourn = as.numeric( dat$last.date - dat$trt_date, units = "days")/365.2425
sojourn[death] =  as.numeric( dat$death_date[death] - dat$trt_date[death], units = "days")/365.2425
cen = Surv(sojourn, ltfu)

# Adjust for complete variables

year.grp = factor(as.numeric(format(dat$trt_date, "%Y")),2006:2017,
              labels = rep(c("2006-2009","2010-2013","2014-2017"),each=4))
age = as.numeric(dat$trt_date-dat$birth_date, units = "days")/365.2425
genderM = as.numeric(dat$gender== "Male")
maritalM = as.numeric(dat$marital=="Married-MARRIED")
raceW = as.numeric(dat$race=="White-WHITE")
obesity = as.numeric(dat$bmi.comb >= 30)
log_LACcum = log(1+dat$LAC.cum)
dat$nobmi.comb = is.na(dat$bmi.comb)
dat$nobmi_at_surg.comb = F
dat$nobmi_at_surg.comb[which(dat$bmi.comb.gap<= -30)] = T
dat$nobmi_at_surg.comb[which(dat$bmi.comb.gap> 365.2425)] = T
tmp.pos = dat$nobmi.comb | dat$nobmi_at_surg.comb
obesity[tmp.pos] = as.numeric(dat$obesity_new[tmp.pos])
Z.match = model.matrix(~genderM+ stage
                  + adhesion + seg)[,-1]
Z.match[, "stage2"] = pmax(Z.match[, "stage2"],Z.match[, "stage3"])
Z = model.matrix(~age+genderM+ raceW+obesity+stage
                 + adhesion + seg + right.gen + sigmoid.gen)[,-1]
Z[, "stage2"] = pmax(Z[, "stage2"],Z[, "stage3"])

# Add EHR phecodes
dat.dx.1yr = read.csv("data/paper surg/CRC_surg_20210201_Phecode_1yr.csv")
dat.dx.full = read.csv("data/paper surg/CRC_surg_20210201_Phecode_full.csv")
dat.dx.1yr = dat.dx.1yr[match(dat$patientNum, dat.dx.1yr$patientNum),-1]
dat.dx.full = dat.dx.full[match(dat$patientNum, dat.dx.full$patientNum),-1]
dat.dx.1yr = log(1+dat.dx.1yr[,apply(dat.dx.1yr!=0,2,sum)>20])
dat.dx.full = log(1+dat.dx.full[,apply(dat.dx.full!=0,2,sum)>20])

dat.dx.1yr$PheCode.153 = NULL
dat.dx.1yr$PheCode.278 = NULL
dat.dx.full$PheCode.153 = NULL
dat.dx.full$PheCode.278 = NULL

colnames(dat.dx.1yr) = gsub("\\.",'_',colnames(dat.dx.1yr))
colnames(dat.dx.1yr) = paste0(colnames(dat.dx.1yr), "_1yr")
colnames(dat.dx.full) = gsub("\\.",'_',colnames(dat.dx.full))

dx.comb.full = which(!grepl("PheCode", colnames(dat.dx.full)))
dx.comb.1yr = which(!grepl("PheCode", colnames(dat.dx.1yr)))


Z = cbind(Z, 
          as.matrix(dat.dx.full[,dx.comb.full]), 
          as.matrix(dat.dx.1yr[,dx.comb.1yr]), 
          as.matrix(dat.dx.full[,-dx.comb.full]), 
          as.matrix(dat.dx.1yr[,-dx.comb.1yr]))


Z.trt = trt*Z
colnames(Z.trt) = paste("LAC",colnames(Z), sep='_')
Z.trt = cbind(Z.trt)
year1417 = year.grp == "2014-2017"
year1017 = (year.grp == "2010-2013") | year1417
Z.1017 = year1017*Z
colnames(Z.1017) = paste(colnames(Z), "1017", sep='_')
Z.1417 = year1417*Z
colnames(Z.1417) = paste(colnames(Z), "1417", sep='_')

Z.trt.1017 = trt*year1017*Z
colnames(Z.trt.1017) = paste("LAC", colnames(Z), "1017", sep='_')
Z.trt.1417 = trt*year1417*Z
colnames(Z.trt.1417) = paste("LAC", colnames(Z), "1417", sep='_')

trt1017 = trt*year1017
trt1417 = trt*year1417

Z.main = cbind(year1017, year1417, Z, 
               Z.1017, Z.1417)
Z.inter = cbind(trt1017, trt1417,Z.trt, 
                Z.trt.1017, Z.trt.1417)


n= length(surv)


Z.main.inter = Z.main[,apply(Z.inter>0, 2, sum) >= 20 ]
Z.inter = Z.inter[,apply(Z.inter>0, 2, sum) >= 20]
Z.main = Z.main[,apply(Z.main>0, 2, sum) >= 20 ]

year= as.numeric(format(dat$trt_date, "%Y"))
# year.grp = year
# year = as.numeric(format(dat$trt_date, "%Y"))
# datZ = data.frame(age,genderM,raceW,obesity,stage,year.grp,
#              prior_cancer, adhesion, obstruct, seg,
#              year)
# year=year.grp

seg.rct = factor(dat.rct$pri_tum, 1:3,
                 labels = c("Right", "Left", "sigmoid"))
stage.rct = factor(dat.rct$stage, levels = c(0:3),
                   labels = c("0-1","0-1",2:3))
adhesion.rct = as.numeric(dat.rct$bow_adh==2)
genderM.rct = as.numeric(dat.rct$SEX == 'm')
Z.rct = model.matrix(~ genderM.rct + stage.rct + 
                         adhesion.rct + seg.rct)[,-1]
Z.rct[, "stage.rct2"] = pmax(Z.rct[, "stage.rct2"],Z.rct[, "stage.rct3"])
colnames(Z.rct) = gsub(".rct", '', colnames(Z.rct))

id = dat$patientNum

save(surv.rct,trt.rct, Z.rct, Z.match, 
     surv,trt,Z.main, Z.inter, Z.main.inter, 
     year.grp, year, log_LACcum, id,   
     file = "data/analysis/paper1_elig_phecode.rda")
