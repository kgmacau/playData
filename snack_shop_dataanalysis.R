
# ���R�ռ�
rm(list = ls())

# ����R��
library(readxl)
library(summarytools)
library(dplyr)
library(expss)
library(qwraps2)
library(Hmisc)

# library(ReporteRs) 
# ���������ֱ�Ӳ���WORD����������Ŀǰ��R Cran���Ѿ��Ƴ����ݲ�����

# ��ȡ����
setwd("C:/Users/212697818/Desktop/Data")
dt=read_excel("snack_shop_data.xls")

labs<-paste(c(1, 10, 100, 1000, 10000), seq="��", seq="-",
            c(10, 100, 1000, 10000, Inf), seq="��")

# ����һ���������ķ�������
dt$cat <- cut(dt$������, breaks = c(10000, 100000, 1000000, 10000000, 100000000, Inf),  
              labels = labs, right = FALSE)
dt$dummy="total"

# �򵥷�����������������
table(dt$cat)

# �����������������ݵļ򵥱���
dfSummary(dt$cat)

# ���߱�
library(arsenal)
table_one <- tableby(dummy ~ cat, data = dt)
summary(table_one, title = "�������ݱ�")

# �������߱�
library(table1)
label(dt$cat) <- "��������������"
table1::table1(~cat, data = dt)
table1::table1(~�����ղ��� + ���۽�� | cat, data = dt)

## ���۶���ղ����Ĺ�ϵ
attach(dt)
dt<-rename(dt, collect_number=�����ղ���, sale_money=���۽��, 
                                        sale_number=������)
label(dt$collect_number) <- "Collection Number"
label(dt$sale_money) <- "Sale Money"
label(dt$sale_number) <- "Sale Number"
dt<-dt[dt$collect_number>0, ] # ɾ���ղ���Ϊ0������

# �ع�ģ��
model<-lm(sale_money~collect_number+sale_number, data=dt)
summary(model)

# �ع�ģ�����ɱ���
library(sjPlot)
tab_model(model)

library(olsrr)
ols_step_both_p(model, pent = 0.1, prem = 0.3, details = FALSE)


# ��ͼ
boxplot(collect_number/10000000~cat,data=dt, main="�����ղ�������ͼ",
        xlab="����������", ylab="�����ղ��� ����λ��ǧ��")

boxplot(sale_money/10000000~cat,data=dt, main="���۽������ͼ",
        xlab="����������", ylab="���۽�� ����λ��ǧ��Ԫ��")

barchart(cat, xlab="Ƶ��")



# �ο�����:
# https://rstudio-pubs-static.s3.amazonaws.com/222993_e1059369754f419a9360e7b0d431f3e1.html
# https://dabblingwithdata.wordpress.com/2018/01/02/my-favourite-r-package-for-summarising-data/
# https://cran.r-project.org/web/packages/expss/vignettes/tables-with-labels.html
# https://cran.r-project.org/web/packages/qwraps2/vignettes/summary-statistics.html
# https://thatdatatho.com/2018/08/20/easily-create-descriptive-summary-statistic-tables-r-studio/
# https://cran.r-project.org/web/packages/sjPlot/vignettes/tab_model_estimates.html