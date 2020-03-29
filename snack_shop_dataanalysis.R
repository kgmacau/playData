
# 清空R空间
rm(list = ls())

# 调用R包
library(readxl)
library(summarytools)
library(dplyr)
library(expss)
library(qwraps2)
library(Hmisc)

# library(ReporteRs) 
# 这个包可以直接产生WORD报表，但是目前聪R Cran中已经移除，暂不能用

# 读取数据
setwd("C:/Users/212697818/Desktop/Data")
dt=read_excel("snack_shop_data.xls")

labs<-paste(c(1, 10, 100, 1000, 10000), seq="万", seq="-",
            c(10, 100, 1000, 10000, Inf), seq="万")

# 生成一个销售量的分类数据
dt$cat <- cut(dt$销售量, breaks = c(10000, 100000, 1000000, 10000000, 100000000, Inf),  
              labels = labs, right = FALSE)
dt$dummy="total"

# 简单分析销售量分类数据
table(dt$cat)

# 做出销售量分类数据的简单表格
dfSummary(dt$cat)

# 三线表
library(arsenal)
table_one <- tableby(dummy ~ cat, data = dt)
summary(table_one, title = "销售数据表")

# 精美三线表
library(table1)
label(dt$cat) <- "销售量分类数据"
table1::table1(~cat, data = dt)
table1::table1(~店铺收藏量 + 销售金额 | cat, data = dt)

## 销售额和收藏量的关系
attach(dt)
dt<-rename(dt, collect_number=店铺收藏量, sale_money=销售金额, 
                                        sale_number=销售量)
label(dt$collect_number) <- "Collection Number"
label(dt$sale_money) <- "Sale Money"
label(dt$sale_number) <- "Sale Number"
dt<-dt[dt$collect_number>0, ] # 删除收藏量为0的数据

# 回归模型
model<-lm(sale_money~collect_number+sale_number, data=dt)
summary(model)

# 回归模型做成表格
library(sjPlot)
tab_model(model)

library(olsrr)
ols_step_both_p(model, pent = 0.1, prem = 0.3, details = FALSE)


# 作图
boxplot(collect_number/10000000~cat,data=dt, main="店铺收藏数箱形图",
        xlab="销售量分类", ylab="店铺收藏数 （单位：千万）")

boxplot(sale_money/10000000~cat,data=dt, main="销售金额箱形图",
        xlab="销售量分类", ylab="销售金额 （单位：千万元）")

barchart(cat, xlab="频数")



# 参考文献:
# https://rstudio-pubs-static.s3.amazonaws.com/222993_e1059369754f419a9360e7b0d431f3e1.html
# https://dabblingwithdata.wordpress.com/2018/01/02/my-favourite-r-package-for-summarising-data/
# https://cran.r-project.org/web/packages/expss/vignettes/tables-with-labels.html
# https://cran.r-project.org/web/packages/qwraps2/vignettes/summary-statistics.html
# https://thatdatatho.com/2018/08/20/easily-create-descriptive-summary-statistic-tables-r-studio/
# https://cran.r-project.org/web/packages/sjPlot/vignettes/tab_model_estimates.html