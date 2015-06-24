library(shiny)

# Make some fake data
clinic_values <- data.frame(month_year = factor(x = c("Jan 2015","Feb 2015","Mar 2015","Apr 2015","May 2015","Jun 2015"),
                                                levels = c("Jan 2015","Feb 2015","Mar 2015","Apr 2015","May 2015","Jun 2015"),
                                                labels = c("Jan 2015","Feb 2015","Mar 2015","Apr 2015","May 2015","Jun 2015")),
                            ob.hgba1c = c(6.2,6.4,6.3,6.1,5.9,5.8),
                            bf.hgba1c = c(7.3,7.5,7.4,7.3,7.2,7.3),
                            ej.hgba1c = c(8.1,7.5,7.3,6.9,6.7,6.5),
                            rv.hgba1c = c(6.6,6.9,7.2,7.4,7.7,7.9),
                            ob.bmi = c(22.2,22.6,23.5,23.3,23.0,22.9),
                            bf.bmi = c(31.0,33.0,34.0,33.0,32.3,31.1),
                            ej.bmi = c(44.9,41.1,39.9,39.3,37.0,35.5),
                            rv.bmi = c(28.8,28.6,28.1,26.6,25.9,25.8))

shinyServer(func = function(input,output){
    
    output$historical_data_plot <- renderPlot(expr = {
        
        # This selects a few columns for inclusion in the data
        # It also orders the data frame (probably not necessary, but not a bad thing)
        active_df <- clinic_values[c("month_year",paste(input$site,input$measure,sep = "."))]
        active_df <- active_df[order(active_df$month_year),]
        
        # This vector is used to label the Y axis
        yaxis_labels <- c(bmi = "Body Mass Index",
                          hgba1c = "Hemoglobin A1C")
        
        # This vector is used to color the output
        colored_sites <- c(ob = "blue",
                           bf = "red",
                           ej = "dark green",
                           rv = "gold")

        # This list is used to select y limits for specific measures
        # Obviously, this could be done programmatically - this is done for simplicity
        ylims <- list(bmi = c(20,50),
                      hgba1c = c(5.5,8.5))
        
        # This list lets us put the nice labels back into things
        site_names <- c(ob = "Oak Bridge",
                        bf = "Birchfield",
                        ej = "East Jonestown",
                        rv = "Robertsville")

        # Start by plotting the mean
        # Then, a loop plots the selected sites
        plot(x = 1:nrow(active_df),
             y = rowMeans(active_df[paste(input$site,input$measure,sep = ".")]),
             type = "l",
             col = "dark gray",
             xaxt = "n",
             lty = 2,
             xlab = "Month",
             ylab = yaxis_labels[[input$measure]],
             ylim = ylims[[input$measure]])
        axis(side = 1,at = 1:6,labels = clinic_values$month_year)
        
        for(x in input$site) {
            
            lines(x = 1:nrow(active_df),
                  y = active_df[[paste(x,input$measure,sep = ".")]],
                  type = "l",
                  col = colored_sites[[x]])
        }
        
        legend(x = "top",
               legend = c("Mean",site_names[input$site]),
               lty = c(2,rep(x = 1,times = length(input$site))),
               col = c("dark gray",colored_sites[input$site]))
    })
})
