import excel "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/CI_Dataset.xlsx", sheet("Updated Dataset") firstrow
save "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/CI_Dataset.dta", replace

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/CI_Dataset.dta", clear

xtset CountryID Year
tabulate region, g(m)
rename m1 AS
rename m2 EAP
rename m3 ECA
rename m4 LAC
rename m5 SA
rename m6 SSA


xtline HDI_100
xtline Account
xtline Borrow
xtline Save



* bar graph of every region on HDI
graph hbar (mean) HDI, over(region, sort(HDI) descending label(labsize(small))) bar(1, lwidth(none)) blabel(bar, size(small) color(black) margin(tiny) format(%3.1g)) ytitle(Mean of HDI) title(HDI and Regions (2011-2021)) graphregion(margin(vsmall))

* bar graph of every country on HDI
graph hbar (mean) HDI, over(Country, sort(HDI) descending label(labsize(tiny))) bar(1, lwidth(none)) blabel(bar, size(tiny) color(black) margin(tiny) format(%3.1g)) ytitle(Mean of HDI) title(HDI and Countries (2011-2021)) graphregion(margin(vsmall))

* bar graph of Account, Borrow, Savings
graph bar (mean) Account Borrow Save, over(region) legend(size(small))

* scatterplot by country w lfit and ci (account)
collapse(mean) HDI Account, by(Country)
br
twoway(lfitci HDI Account)(scatter HDI Account, sort mlabel(Country)) 
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/CI_Dataset.dta", clear

* scatterplot by country w lfit and ci (borrow)
collapse(mean) HDI Borrow, by(Country)
br
twoway(lfitci HDI Borrow)(scatter HDI Borrow, sort mlabel(Country)) 
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/CI_Dataset.dta", clear

* scatterplot by country w lfit and ci (save)
collapse(mean) HDI Save, by(Country)
br
twoway(lfitci HDI Save)(scatter HDI Save, sort mlabel(Country)) 
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/CI_Dataset.dta", clear

* scatterplot by hdicode (high low medium)
collapse(mean) HDI Account, by(hdicode)
br
twoway(lfitci HDI Account)(scatter HDI Account, sort mlabel(hdicode))
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/CI_Dataset.dta", clear

* scatterplot by region
collapse HDI Account, by(region)
br
twoway(lfitci HDI Account)(scatter HDI Account, sort mlabel(region))
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/CI_Dataset.dta", clear

//Arab States
//East Asia and the Pacific
//Europe and Central Asia
//Latin America and the Caribbean
//South Asia
//Sub-Saharan Africa

******
collapse(mean) HDI Account, by(Country region)
sort(region)
br
* for AS countries
twoway(lfitci HDI Account)(scatter HDI Account in 1/6, sort mlabel(Country))
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/PI_Dataset.dta", clear
******
collapse(mean) HDI Account, by(Country region)
sort(region)
br
* for EAP countries
twoway(lfitci HDI Account)(scatter HDI Account in 7/13, sort mlabel(Country))
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/PI_Dataset.dta", clear
******
collapse(mean) HDI Account, by(Country region)
sort(region)
br
* for ECA countries
twoway(lfitci HDI Account)(scatter HDI Account in 14/17, sort mlabel(Country))
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/PI_Dataset.dta", clear
******
collapse(mean) HDI Account, by(Country region)
sort(region)
br
* for LAC countries
twoway(lfitci HDI Account)(scatter HDI Account in 18/22, sort mlabel(Country))
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/PI_Dataset.dta", clear
******
collapse(mean) HDI Account, by(Country region)
sort(region)
br
* for SA countries
twoway(lfitci HDI Account)(scatter HDI Account in 23/29, sort mlabel(Country))
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/PI_Dataset.dta", clear
******
collapse(mean) HDI Account, by(Country region)
sort(region)
br
* for SSA countries
twoway(lfitci HDI Account)(scatter HDI Account in 30/61, sort mlabel(Country))
clear

use "/Users/johnmichaelmarquez/Desktop/NCCU Spring 2023/Causal Inference/Research/Term Paper/rawdata/PI_Dataset.dta", clear

** correlation matrix
estpost correlate HDI_100 Account Borrow Save FDI GDP Giniindex Inflationrate Literacyrate Primarycompletionrate TradeofGDP ControlofCorruption GovernmentEffectiveness PoliticalStabilityandAbsence RegulatoryQualityEstimate RuleofLawEstimate  VoiceandAccountabilityEstima Accesstocleanfuelsandtechno Accesstoelectricityofpopu Agedependencyratioofworki Centralgovernmentdebttotal Currenteducationexpendituret Currenthealthexpenditureof Domesticgeneralgovernmentheal Educationalattainmentatleast Employmenttopopulationratio Fertilityratetotalbirthspe Governmentexpenditureoneducat IndividualsusingtheInternet Laborforceparticipationrate Mobilecellularsubscriptions Netmigration Peopleusingatleastbasicdrin Peopleusingatleastbasicsani Peopleusingsafelymanageddrin Peoplewithbasichandwashingfa Populationgrowthannual Ruralpopulationoftotalpop TaxrevenueofGDP Unemploymenttotaloftotal Urbanpopulationoftotalpop, matrix listwise

set matsize 1000
est store c1
esttab * using cormatrix.csv, unstack not noobs compress

*** Machine learning: Post-double selection method to select covariates

pdslasso HDI_100 Account (FDI-Urbanpopulationoftotalpop),rob
regress HDI_100 Account GovernmentEffectiveness Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual,vce(robust)
xtreg HDI_100 Account GovernmentEffectiveness Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, robust fe

* FINAL: w dummy variables
pdslasso HDI_100 Account SSA (FDI-Urbanpopulationoftotalpop),rob
regress HDI_100 Account SSA FDI GDP GovernmentEffectiveness Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual,vce(robust)
xtreg HDI_100 Account SSA FDI GDP GovernmentEffectiveness Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, fe vce(robust)

pdslasso HDI_100 Borrow SSA (FDI-Urbanpopulationoftotalpop),rob
regress HDI_100 Borrow SSA FDI GDP GovernmentEffectiveness Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust)
xtreg HDI_100 Borrow SSA FDI GDP GovernmentEffectiveness Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, robust fe

pdslasso HDI_100 Save SSA (FDI-Urbanpopulationoftotalpop),rob
regress HDI_100 Save SSA GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust)
xtreg HDI_100 Save SSA GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, robust fe



regress HDI_100 Account Borrow Save, vce(robust)
pdslasso HDI_100 Account Borrow Save SSA (FDI-Urbanpopulationoftotalpop), rob
regress HDI_100 Account Borrow Save SSA, vce(robust)
regress HDI_100 Account SSA FDI GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust)
regress HDI_100 Borrow SSA FDI GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust)
regress HDI_100 Save SSA FDI GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust)
regress HDI_100 Account Borrow Save SSA FDI GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust)
regress HDI_100 Account Borrow SSA FDI GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust)
regress HDI_100 Save Borrow SSA FDI GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust)

outreg2 using text1.xls, replace
xtreg HDI_100 Account Borrow Save FDI GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust) fe
xtreg HDI_100 Account Borrow FDI GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust) fe
xtreg HDI_100 Account Save FDI GDP GovernmentEffectiveness RuleofLawEstimate Agedependencyratioofworki Fertilityratetotalbirthspe Populationgrowthannual, vce(robust) fe


outreg2 using text2.xls, replace
		

rlasso HDI (FDI-Urbanpopulationoftotalpop), rob
rlasso Account (FDI-Urbanpopulationoftotalpop), rob
rlasso Savings (FDI-Urbanpopulationoftotalpop), rob
rlasso Borrow (FDI-Urbanpopulationoftotalpop), rob


