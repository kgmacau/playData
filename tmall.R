

# ���R�ռ�
rm(list = ls())

install.packages("rvest")

library(rvest)


# ֽ���
gurl <- "https://list.tmall.com/search_product.htm?q=%C9%AD%B1%C8%B0%C2&type=p&vmarket=&spm=875.7931836%2FB.a2227oh.d100&from=mallfp..pc_1_searchbutton"

# ������
gurl<-"https://list.tmall.com/search_product.htm?q=%C0%B1%BD%B7%BD%B4&type=p&spm=a220m.1000858.a2227oh.d100&from=.list.pc_5_searchbutton"

md <- gurl %>% 
        read_html(encoding="GBK") %>% # ��ȡgurl�����ӣ�ָ������Ϊgbk
        html_nodes("div.product-iWrap")  # ɸѡ�����а�����<div class="product-iWrap">...</div>�������

# ץȡ�����ǳƺ�ID
sellerNick <- md %>% html_nodes("p.productStatus>span[class]") %>% 
        html_attr("data-nick")  

sellerId <- md %>% html_nodes("p.productStatus>span[data-atp]") %>% 
        html_attr("data-atp") %>% 
        gsub(pattern="^.*,",replacement="")

# ץȡ�������Ƶ�����
itemTitle <- md %>% html_nodes("p.productTitle>a[title]") %>% 
        html_attr("title")

itemId <- md %>% html_nodes("p.productStatus>span[class]") %>% 
        html_attr("data-item")

price <- md %>% html_nodes("em[title]") %>% 
        html_attr("title") %>% 
        as.numeric

volume <- md %>% html_nodes("span>em") %>% 
        html_text

options(stringsAsFactors = FALSE) # �����ַ������Զ�ʶ��Ϊ����

itemData <- data.frame(sellerNick=sellerNick,
                       sellerId=sellerId,itemTitle=itemTitle,
                       itemId=itemId,
                       price=price,
                       volume=volume)



save(itemData,file="C:/Users/212697818/Desktop/itemData.rData")
write.csv(itemData,file="C:/Users/212697818/Desktop/itemData.csv")



# Reference
# https://www.jianshu.com/p/f768cbf5ee0c