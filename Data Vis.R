library(tidyverse)
#-------------Chapitre 3.2 First Steps--------------#
#1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg)

#2. How many rows are in mpg? How many columns?
nrow(mtcars)
ncol(mtcars)

#3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg 
#4. Make a scatterplot of hwy vs cyl
ggplot(data=mpg) + geom_point(aes(x = hwy, y = cyl, shape=class))
ggplot(data=mpg,aes(x = hwy, y = cyl))+geom_count()
ggplot(data=mpg,aes(x = hwy, y = cyl))+geom_jitter()

(by_class <- group_by(mpg,class))
summarise(by_class, n=n(), moy=mean(displ, na.rm = TRUE), moy_hwy=mean(hwy, na.rm = TRUE))

ggplot(mpg, aes(x= displ, y= hwy, color = class, shape = class))+scale_shape_manual(values=1:nlevels(mpg$class))+geom_point()

by(mpg[, c("displ", "hwy")], list(class = mpg$class), summary) # ecriture sans dplyr

#note, 4 trace le table : table(mpg$hwy, mpg$cyl)

#5. What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
ggplot(mpg)+ geom_point(aes(x = class, y = drv))



#-------------Chapitre 3.3 aesthetic mapping --------------#
#1. 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
#2. Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset). How can you see this information when you run mpg?
  
#3. Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(mpg)+geom_point(aes(x=cty,y=cyl,size=class,color=manufacturer), shape=21) 

#4. What happens if you map the same variable to multiple aesthetics?
ggplot(mpg)+geom_point(aes(x=cty,y=year,color=class,shape=manufacturer),color=blue, shape=21) 
  
#5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5,stroke = 2)
#6. What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)? Note, you’ll also need to specify x and y.
ggplot(mpg)+geom_point(aes(x=cty,y=year,color=displ < 5)) 

#-------------Chapitre 3.4 Common problems --------------#
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

#-------------Chapitre 3.5 Facets --------------#
# facet_wrap
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 3)
# facet_grid
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ class)
#What happens if you facet on a continuous variable?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ cty)
  
#What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))+
 facet_grid(drv ~ cyl)
  
#What plots does the following code make? What does . do?
  
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

#Take the first faceted plot in this section:
  ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
#What are the advantages to using faceting instead of the colour aesthetic? 
#What are the disadvantages? How might the balance change if you had a larger dataset?
  
#Read ?facet_wrap. What does nrow do? What does ncol do? 
#What other options control the layout of the individual panels? 
#Why doesn’t facet_grid() have nrow and ncol arguments?
  
#When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?

  #-----------------------3.6 Geometric objects--------------------------#
ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy, color = drv))+
    geom_smooth(mapping = aes(x = displ, y = hwy, color = drv))
#What geom would you use to draw a line chart? 
#A boxplot? A histogram? An area chart?
# histogram
f <- ggplot(mpg, aes(class, hwy))
f + geom_col()
#boxplot
f <- ggplot(mpg, aes(class, hwy))
f + geom_boxplot()
# area chart
i <- ggplot(economics, aes(date, unemploy))
i + geom_area()
#a line chart
i <- ggplot(economics, aes(date, unemploy))
i + geom_line(color="red", alpha=0.5)

#Run this code in your head and predict what the output will look like. 
#Then, run the code in R and check your predictions.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se=FALSE)
#What does show.legend = FALSE do? What happens if you remove it?
#Why do you think I used it earlier in the chapter?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = drv),show.legend = FALSE) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv),show.legend = FALSE,se=FALSE)

# What does the se argument to geom_smooth() do?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se=FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth()
#Recreate the R code necessary to generate the following graphs.
#1
ggplot(data = mpg, aes(x = displ, y=hwy))+
geom_point()+
geom_smooth(se=FALSE, color="blue")
#2

ggplot(data = mpg, aes(x = displ, y=hwy))+
  geom_point()+
  geom_smooth(se=FALSE,aes(x = displ, y=hwy, z=drv),method = 'loess')

#or better

ggplot(data = mpg, aes(x = displ, y=hwy))+
  geom_point()+
  geom_smooth(se=FALSE,aes(x = displ, y=hwy, group=drv),method = 'loess')

#3

ggplot(data = mpg, aes(x = displ, y=hwy))+
  geom_point(aes(x = displ, y=hwy,color=drv))+
  geom_smooth(se=FALSE,aes(x = displ, y=hwy, color=drv),method = 'loess')

#4
ggplot(data = mpg, aes(x = displ, y=hwy))+
  geom_point(aes(x = displ, y=hwy,color=drv))+
  geom_smooth(se=FALSE,aes(x = displ, y=hwy),method = 'loess')

#5

ggplot(data = mpg, aes(x = displ, y=hwy))+
  geom_point(aes(x = displ, y=hwy,color=drv))+
  geom_smooth(se=FALSE,aes(linetype=drv),method = 'loess')

# 6
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv),shape=21,size = 4, fill = "white", stroke=5) 

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color="white", size=4)+
  geom_point(aes(color = drv),size = 2) 
#---------------------3.7 Statistical transformations--------
# les 2 suivant donne le meme resultat
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

#stat_summary(), which summarises the y values for each unique x value,

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )
#1. What is the default geom associated with stat_summary()? 
#How could you rewrite the previous plot to use that geom function 
#instead of the stat function?
ggplot(data = diamonds) + geom_pointrange(aes(x = cut, y = depth), stat = "summary",fun.ymin = min, fun.ymax = max,fun.y = median)

#What does geom_col() do? How is it different to geom_bar()?

ggplot(data = diamonds) + geom_col(aes(x = cut, y = price)) #il fait la somme de depth pour chaque cut.
ggplot(data = diamonds) + geom_bar(aes(x = cut))

ggplot(data = diamonds) + geom_point(aes(x = carat, y = price))+
  facet_wrap (~ clarity)
ggplot(data=diamonds) + geom_point(aes(x = carat, y = price, color=clarity), alpha=0.2)+ geom_smooth(aes(x = carat, y = price, color=clarity), size=1,se=FALSE)
                                    
                                    
#Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make a list of all the pairs. What do they have in common?
  
#What variables does stat_smooth() compute? What parameters control its behaviour?


# In our proportion bar chart, we need to set group = 1. Why? In other words what is the problem with these two graphs?
  
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = 1))



#----3.8 Position adjustments--------

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size= hwy))

#1. What is the problem with this plot? How could you improve it?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cty, y = hwy, size=hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cty, y = hwy), position="jitter")
#2. What parameters to geom_jitter() control the amount of jittering?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy))+ 
  geom_jitter()
  
  
#3. Compare and contrast geom_jitter() with geom_count().

P1 <- ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()

P2 <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cty, y = hwy, size=hwy))
grid.arrange(P1, P2, ncol=2)


#4. What’s the default position adjustment for geom_boxplot()? 
#Create a visualisation of the mpg dataset that demonstrates it.
plot_p_id <- ggplot(data = mpg, mapping = aes(x = class, y = hwy), position="identity") +
  geom_boxplot()
plot_p_j <- ggplot(data = mpg, mapping = aes(x = class, y = hwy), position="jitter") +
  geom_boxplot()
plot_p_fill <- ggplot(data = mpg, mapping = aes(x = class, y = hwy), position="fill") +
  geom_boxplot()
plot_p_dodge <- ggplot(data = mpg, mapping = aes(x = class, y = hwy) )+
  geom_point()+
  geom_count()
grid.arrange(plot_p_fill, plot_p_dodge, ncol=2, nrow=2)

#----3.9 Coordinate systems --------

#map
fr <- map_data("france")

ggplot(fr, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")+
  coord_quickmap()

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()



#polar coordinate
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

grid.arrange(bar + coord_flip(), bar + coord_polar(), ncol=2, nrow=2)

#Turn a stacked bar chart into a pie chart using coord_polar().
ggplot(mpg, aes(x = class, fill=class), 
       show.legend = FALSE,
       width = 1)+
geom_bar()+
coord_polar()

table(mpg$class)
#What does labs() do? Read the documentation.

ggplot(mpg, aes(x = class, fill=class), 
       show.legend = FALSE,
       width = 1)+
  geom_bar()+
  coord_polar()+
  labs(title = "class")

#What’s the difference between coord_quickmap() and coord_map()?

ggplot(nz) +
  geom_polygon( aes(long, lat, group = group), fill = "white", colour = "black") +
  coord_map("cylindrical")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_map()


#What does the plot below tell you about the relationship between city and highway mpg? Why is coord_fixed() important? What does geom_abline() do?
  
plot1 <- ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()+
  geom_point() + 
  geom_abline() +
  coord_fixed()

plot2 <- ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline()
grid.arrange(plot1, plot2, ncol=2, nrow=2)

