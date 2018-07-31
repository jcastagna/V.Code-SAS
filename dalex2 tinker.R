
library(ISLR)
library(tidyverse)

library(boot)

library(lime)
library(DALEX)
library(broom)
library(randomForest)
library(gamlss)

#Data
Default=Default

#Wrangle
Default <- Default %>% mutate(default2=ifelse(default=="No",0,1))

Default %>% head()
Default %>% str()
Default %>% summary()

#make models
CD.lm <- lm(default2~balance + student + income, data = Default)
CD.lm %>% glance()
CD.lm %>% tidy()
CD.lm %>% augment() %>% 
  ggplot(aes(x=.fitted,y=.resid,colour=default2))+
  geom_point(alpha=0.3)

#plot(CD.lm, colors=Default$default2)


CD.glm <- glm(default2~balance + student + income, family = "binomial", data = Default)
CD.glm %>% glance()
CD.glm %>% tidy()

CD.rf <- randomForest(default2~balance + student + income, data = Default)
CD.rf %>% summary()

CD.gamlss <- gamlss(default2~balance + student, data = Default, family=NO)
CD.gamlss %>% summary()

# Create model Explainers
explainer_lm <- explain(CD.lm, 
                        data = Default[,c(2:4)], y = Default[,5], label="my.lm")

explainer_glm <- explain(CD.glm, 
                        data = Default[,c(2:4)], y = Default[,5],label="my.glm")

explainer_rf <- explain(CD.rf, 
                         data = Default[,c(2:4)], y = Default[,5])

explainer_gamlss <- explain(CD.gamlss, 
                        data = Default[,c(2:4)], y = Default[,5])

mp_lm <- model_performance(explainer_lm)
mp_glm <- model_performance(explainer_glm)
mp_rf <- model_performance(explainer_rf)
#mp_gamlss <- model_performance(explainer_gamlss)

plot(mp_lm, mp_glm,mp_rf)
plot(mp_glm)
plot(mp_rf)
plot(mp_gamlss)

plot(mp_lm, mp_rf, geom="boxplot")
plot(mp_lm, mp_glm,mp_rf, geom="boxplot")

# Vraiable expaliners
vi_lm <- variable_importance(explainer_lm, loss_function = loss_root_mean_square)
vi_lm
vi_glm <- variable_importance(explainer_glm, loss_function = loss_root_mean_square)
vi_glm


vi_rf <- variable_importance(explainer_rf, loss_function = loss_root_mean_square)
vi_rf
plot(vi_lm,vi_rf)
plot(vi_glm)

