sysuse auto.dta 

local file stat_tag_01

sum price 

**>>>ST:Value(Label="total n", Frequency="On Demand", Type="Default")
di r(N) 
**<<<

sum price if for==0 
di r(N) 

sum price if for==1 
di r(N)

twoway (scatter price mpg) (lfit price mpg), saving(output/g1_stat_tag_01.gph, replace) 

**>>>ST:Value(Label="figure 1", Frequency="On Demand", Type="Default")
gr export output/g1_stat_tag_01.png, replace 
**<<<
