library(nycflights13)
library(tidyverse)
nycflights13::flights
(jan1 <- filter(flights, month == 1, day == 1))
(dec25 <- filter(flights, month == 12, day == 25))
filter(flights, !(arr_delay > 120 | dep_delay > 120))
(nov_dec <- filter(flights, month %in% c(11, 12)))
ncol(flights) #Afficher le nombre de colonne
nrow(flights)
attributes(flights) # Afficher le nb de col et ligne
length(flights) #Afficher le nombre de colonne
names(flights)

#--------------Chapitre 5.2 filter()--------------------#

#Had an arrival delay of two or more hours
df<-dplyr::filter(flights, arr_delay >= 120)
summary(df$arr_delay)
dplyr::summarise(df) ##??? 

#Flew to Houston (IAH or HOU)
df<-dplyr::filter(flights, (dest=="IAH"|dest=="HOU"))
df %>% select(dest)
summary(df$dest)
table(df$dest)

# Were operated by United, American, or Delta
df<-dplyr::filter(flights, carrier=="UA"|carrier=="AA"|carrier=="DL")
table(.Last.value$carrier)
#Departed in summer (July, August, and September)
dplyr::filter(flights,month>6, month<10)
dplyr::filter(flights,between(month,7,9))
dplyr::filter(flights, month %in% c(7:9))
flights %>% select(flight, month) %>% dplyr::filter(month %in% c(7:9))
# Arrived more than two hours late, but didn’t leave late
dplyr::filter(flights, dep_delay<=0, arr_delay>=120)
flights %>% select(flight, dep_delay) %>% dplyr::filter(dep_delay<0)

# Were delayed by at least an hour, but made up over 30 minutes in flight
dplyr::filter(flights, dep_delay>=60, (dep_delay-arr_delay)>=30)

# Departed between midnight and 6am (inclusive)
dplyr::filter(flights, dep_time<=600|dep_time==2400)
# dplyr::filter(flights, between(dep_time, 1,600) ) 
flights %>% select(flight, dep_time) %>% dplyr::filter(dep_time %in% c(0:600,2400))
flights %>% select(flight, dep_time) %>% dplyr::filter(dep_time<=600|dep_time==2400)


# Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed to answer the previous challenges?


# How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
sum(is.na(flights))
sum(is.na(flights$dep_time))
flights[which(is.na(flights$dep_time)), "dep_time"]
dplyr::flights[which(is.na(flights$dep_time)), c("dep_time", "tailnum")]
dplyr::filter(flights, is.na(dep_time)) %>% select(dep_time) %>% nrow()
flights %>% dplyr::filter(is.na(dep_time), is.na(arr_time)) %>% select(dep_time) %>% nrow()

# ALGO-> for col in 1: nb_col du d flights {sum(is.na(col)) print (names(df)[col])}

for (num_col in 1:ncol(flights)) 
{
  if (sum(is.na(flights[,num_col]))>0) 
  {
    print(names(flights)[num_col])
    print(sum(is.na(flights[,num_col])))
  }

} 

apply (flights[,c(1:2)],2,sum)
apply (is.na(flights),2,sum)

sum_is_na<-function(x) {
  sum(is.na(x))
}

sum_is_na(flights$dep_time)
apply(flights, 2,sum_is_na)



#which(is.na(flights$year))
#which(is.na(flights$sched_dep_time))
sum(is.na(flights$dep_delay))
sum(is.na(flights$arr_time))
#which(is.na(flights$sched_arr_time))
sum(is.na(flights$arr_delay))
#which(is.na(flights$carrier))
#which(is.na(flights$flight))
sum(is.na(flights$tailnum))
#which(is.na(flights$origin))
#which(is.na(flights$dest))
sum(is.na(flights$air_time))
#sum(is.na(flights$distance))
#sum(is.na(flights$hour))
#sum(is.na(flights$minute))
#sum(is.na(flights$time_hour))
# NA ^ 0Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? 
#Can you figure out the general rule? (NA * 0 is a tricky counterexample!)


#logical --> TRUE FALSE NA

#--------------Chapitre 5.3 arrange()--------------------#

#How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
arrange(flights, desc(is.na(dep_time)),
          desc(is.na(dep_delay)),
          desc(is.na(arr_time)), 
          desc(is.na(arr_delay)),
          desc(is.na(tailnum)),
          desc(is.na(air_time))
          )


# trier tous par l'ordre desc avec NA en début
df <-arrange(flights, desc(is.na(dep_time)), desc(dep_time))


#Sort flights to find the most delayed flights. Find the flights that left earliest.
df.most_dep_delay <-arrange(flights, desc(dep_delay))
arrange(flights,dep_delay)

# un petit test pour le tri vectoriel desc(c1,c2)
c1<-c(1,1,1,2,2)
c2<-c(12,11,16,4,13)
t <- tibble(c1,c2)
arrange(t, desc(c1), desc(c2))
arrange(t, desc(c1,c2))

arrange(flights, desc(sum(dep_delay, arr_delay)))

flights %>% mutate(tot_delay=dep_delay+arr_delay) %>% select(flight,dep_delay,arr_delay, tot_delay) %>% arrange(desc(tot_delay))




#Sort flights to find the fastest flights.

flights_copy<-mutate(flights, speed =distance/(arr_time%/%100+(arr_time%%100)/60-dep_time%/%100+(dep_time%%100)/60))
View(flights_copy)
xx<-arrange(flights_copy,desc(speed))
View(xx)

# Which flights travelled the longest? Which travelled the shortest?
head(arrange(flights, desc(distance)))
head(arrange(flights, distance))

#---------------5.4 Select columns with select()-----------------#
select(flights,starts_with("A"))


#Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
select(flights,starts_with("dep_"),starts_with("arr_"))
select(flights, dep_time, dep_delay, arr_time, arr_delay)

#What happens if you include the name of a variable multiple times in a select() call?
select(flights, dep_time, dep_time)

#What does the one_of() function do? Why might it be helpful in conjunction with this vector?
#vars <- c("year", "month", "day", "dep_delay", "arr_delay")
#________??????_________
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))


#Does the result of running the following code surprise you? 
#How do the select helpers deal with case by default? How can you change that default?
#select(flights, contains("TIME"))
select(flights, contains("TIME"))
select(flights, contains("TIME", ignore.case = FALSE))

#---------5.5 Add new variables with mutate()--------------#
#Currently dep_time and sched_dep_time are convenient to look at, 
#but hard to compute with because they’re not really continuous numbers. 
#Convert them to a more convenient representation of number of minutes since midnight.
flights_sml <- select(flights, 
                      dep_time,
                      sched_dep_time,
                      arr_time,
                      sched_arr_time,
                      air_time,
                      dep_delay
                      
)
flights_sml<-mutate(flights_sml, 
                    dep_time_minute=dep_time%/%100*60+dep_time%%100,  
                    sched_dep_time_minute=sched_dep_time%/%100*60+sched_dep_time%%100)

#Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
flights_sml<-mutate(flights_sml, arr_time_minute=(arr_time%/%100*60+arr_time%%100)/1440, 
                    sched_arr_time_minute=(sched_arr_time%/%100*60+sched_dep_time%%100)/1440, 
                    air_minute=arr_time_minute-dep_time_minute,
                    sched_air_time_minute=sched_arr_time_minute-sched_dep_time_minute)  
View(flights_sml)


#Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().
mutate(flights, min_rank(dep_delay))

#Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
flights_sml<-mutate(flights_sml, dep_delay, dep_delay_cal=dep_time_minute-sched_dep_time_minute)
dplyr::filter(flights_sml,dep_delay_cal-(dep_delay%/%100*60+dep_delay%%100) != 0)


View(flights_sml)
#What does 1:3 + 1:10 return? Why?
1:3 + 1:10

#What trigonometric functions does R provide?
x=1/3
cospi(x)==cos(x*pi)

cos(x)
sin(x)
tan(x)

acos(x)
asin(x)
atan(x)
atan2(y, x)

cospi(x)
sinpi(x)
tanpi(x)

#---------------5.4 Grouped summaries with summarise()-----------------#
# 5.6.1 Combining multiple operations with the pipe

boxplot(flights$dep_delay)
base::summary(flights$dep_delay)

dplyr::summarise(flights,min_delay= min(dep_delay,na.rm=TRUE))

# sans pipe

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
  count = n(),
  dist = mean(distance, na.rm = TRUE),
  delay = mean(arr_delay, na.rm = TRUE)
)
delay <- dplyr::filter(delay, count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE) + geom_smooth(se=TRUE)

# avec pipe

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")


# 5.6.2 Missing values
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))


not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))


# 5.6.3 Counts

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)


delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

#Exercise
#1.

#2. Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) (without using count()).

not_cancelled <- flights %>% dplyr::filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% count(dest)
not_cancelled %>% group_by(dest) %>% summarise(n=n())

not_cancelled %>% count(tailnum, wt = distance)
not_cancelled %>% group_by(tailnum, wt = distance)%>% summarise(n=n())


#3. Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is slightly suboptimal. Why? Which is the most important column?

# reponse: le arr_delay est plus important
  
#4. Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?
cancelled <- flights %>% dplyr::filter(is.na(dep_delay), is.na(arr_delay)) %>% group_by(day)
  
#5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? 
#Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

#6. What does the sort argument to count() do. When might you use it?
