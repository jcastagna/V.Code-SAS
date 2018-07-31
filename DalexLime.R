
library(HistData)
library(tidyverse)
library(lime)
library(DALEX)
library(broom)
library(randomForest)


diamonds %>% head()

lm.1 <- diamonds %>% {lm(price ~ carat+cut, data=.)}

lm.1 %>% glance()
lm.1 %>% tidy()
summary(lm.1)

summary(diamonds)


apartments=apartments
apartments %>% str()

## needs to be numeric

apartments_lm_model <- lm(m2.price ~ construction.year + surface + floor + 
                            no.rooms + district, data = apartments)

set.seed(59)
apartments_rf_model <- randomForest(m2.price ~ construction.year + surface + floor + 
                                      no.rooms + district, data = apartments)


apartments_lm_model %>% glance()
apartments_lm_model %>% summary()

predicted_mi2_lm <- predict(apartments_lm_model, apartmentsTest)
sqrt(mean((predicted_mi2_lm - apartmentsTest$m2.price)^2))

predicted_mi2_rf <- predict(apartments_rf_model, apartmentsTest)
sqrt(mean((predicted_mi2_rf - apartmentsTest$m2.price)^2))



explainer_lm <- explain(apartments_lm_model, 
                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)
explainer_rf <- explain(apartments_rf_model, 
                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)

apartments %>% head()
apartmentsTest %>% head()

apartments[,2:6] %>% head()
apartmentsTest[,2:6] %>% head()


mp_lm <- model_performance(explainer_lm)
mp_rf <- model_performance(explainer_rf)
mp_lm
mp_rf

plot(mp_lm,mp_rf)

plot(mp_lm,mp_rf, geom="boxplot")

##
library(auditor)
aud.lm <- auditor::audit(explainer_lm)
aud.lm
aud.rf <- auditor::audit(explainer_rf)
aud.rf
plotResidual(aud.lm,variable="construction.year")
plotResidual(aud.rf,variable="construction.year")


# varimp plots
??variable_importance
vi_rf <- variable_importance(explainer_rf, loss_function = loss_root_mean_square)
vi_lm <- variable_importance(explainer_lm, loss_function = loss_root_mean_square)
vi_lm
vi_rf
plot(vi_lm,vi_rf)

vi2_lm <- variable_importance(explainer_lm, loss_function = loss_root_mean_square, type = "difference")
vi2_rf <- variable_importance(explainer_rf, loss_function = loss_root_mean_square, type = "difference")
plot(vi2_lm, vi2_rf)
 
# other var imp plots
# rf pkg
varImpPlot(apartments_rf_model)

# tradotion regression type mods
library("forestmodel")
forest_model(apartments_lm_model)
??forest_model

library(sjPlot)
sjPlot::plot_model(apartments_lm_model, type = "est", sort.est = TRUE)
??plot_model


sv_rf  <- single_variable(explainer_rf, variable =  "construction.year", type = "pdp")
plot(sv_rf)
sv_lm  <- single_variable(explainer_lm, variable =  "construction.year", type = "pdp")

plot(sv_rf, sv_lm)


sva_rf  <- single_variable(explainer_rf, variable = "construction.year", type = "ale")
sva_lm  <- single_variable(explainer_lm, variable = "construction.year", type = "ale")

plot(sva_rf, sva_lm)


### factor
svd_rf  <- single_variable(explainer_rf, variable = "district", type = "factor")
svd_lm  <- single_variable(explainer_lm, variable = "district", type = "factor")
plot(svd_rf, svd_lm)




#modeldoen

library(modelDown)
#explainer_glm <- DALEX::explain(glm_model, data=HR_data, y=HR_data$left)
#explainer_ranger <- DALEX::explain(ranger_model, data=HR_data, y=HR_data$left)

#explainer_lm <- explain(apartments_lm_model, 
#                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)
#explainer_rf <- explain(apartments_rf_model, 
#                        data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)

modelDown::modelDown(explainer_lm, explainer_rf)


wine <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data",
                   sep=",")
wine_lm_model4 <- lm(quality ~ pH + residual.sugar + sulphates + alcohol, data = wine)


