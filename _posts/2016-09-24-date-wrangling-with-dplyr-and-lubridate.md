---
layout: post
title: "Date Wrangling with dplyr and lubridate"
subtitle: "Converting data.frames to different periods"
categories: [Solutions]
tags: [dplyr, lubridate]
---

When I'm working with financial time series data, I usually use [xts](http://joshuaulrich.github.io/xts/index.html) objects. I convert the data to a data.frame when I'm ready to plot. Sometimes, I find that I want to adjust the periodicity after I've converted the data to a data.frame and dplyr doesn't have a built in To*Period* function to handle this.

There are many ways to do this, but here is a simple method I created using [lubridate] (https://github.com/hadley/lubridate).


{% highlight r %}
library(dplyr)
library(lubridate)
library(knitr)

## Create a simple data.frame object
df = data.frame(
   dt = today() + days(1:300),
   x = runif(300),
   y = runif(300),
   z = runif(300)
)

## Select only the last "Monthly" row for each month
df %>%
  mutate(Monthly = ceiling_date(dt, "months")) %>%  
  group_by(Monthly) %>%
  top_n(n=1, dt) %>%
  ungroup() %>%
  select(-Monthly) %>%
  kable()
{% endhighlight %}



|dt         |         x|         y|         z|
|:----------|---------:|---------:|---------:|
|2016-09-30 | 0.0299440| 0.6439789| 0.3108384|
|2016-10-31 | 0.2269566| 0.5629620| 0.7917520|
|2016-11-30 | 0.9729924| 0.4588632| 0.4912884|
|2016-12-31 | 0.1555810| 0.8060579| 0.1892529|
|2017-01-31 | 0.1473523| 0.0524211| 0.3973115|
|2017-02-28 | 0.6285712| 0.8631682| 0.7659302|
|2017-03-31 | 0.0888469| 0.3566318| 0.2459911|
|2017-04-30 | 0.4924333| 0.3324867| 0.4030350|
|2017-05-31 | 0.2353066| 0.0338763| 0.5916135|
|2017-06-30 | 0.8295749| 0.2122948| 0.3502610|
|2017-07-25 | 0.8999987| 0.3771964| 0.9212028|

This is a very simple method to create periodicity transformation using dplyr and lubridate. The first function creates a new column that distinctly identifies each month/year that each record belongs to using **ceiling_date**. This could be any interval of time from second to hours to quarters, to years. I can also prefix the unit with an integer to create custom intervals ("5 days").

Next, I **group_by** the new column so that it can perform a subset function upon each month. The **top_n** function will return the largest value within a grouping for the field passed (date). If I wanted to return the first observation within each month, simply change the **n** parameter to **-1** (**top_n(n=-1, date)**).

The final two functions are just to clean up the data by ungrouping it and removing the Monthly column.

That is all nice, but if I'm going to be doing this more than once, I would rather have a function to handle it more generically.

{% highlight r %}
ToPeriod = function(.data, field, period, at="endof") {
  ## Use substitute to convert field to a named object
  field = substitute(field)
  
  ## Get date column into its own vector
  #   the deparse function takes a named field
  #   and turns it into a string. This allows us to
  #   reference a column name literally (without quotes)
  #   when calling the function but within the function
  #   we don't have to rely on lazy evaluation which is 
  #   cumbersome to use and hard to debug
  date_values = .data[,deparse(field)]
  index.at.options = c(endof=1, firstof=2)
  index.at = as.integer(index.at.options[at])
  
  ## Set up some new fields so that we can group and 
  ##  pick the top or bottom.
  .data$UNIT = ceiling_date(date_values, period)
  .data$NEWDATEFIELD = date_values
  
  .data = .data %>% 
    group_by(UNIT) %>%
    top_n(index.at, wt = NEWDATEFIELD) %>%
    ungroup() %>%
    select(c(-UNIT, -NEWDATEFIELD))
  return(.data)
}

df %>%
  ToPeriod(dt, "3 months") %>%
  kable()
{% endhighlight %}



|dt         |         x|         y|         z|
|:----------|---------:|---------:|---------:|
|2016-09-30 | 0.0299440| 0.6439789| 0.3108384|
|2016-12-31 | 0.1555810| 0.8060579| 0.1892529|
|2017-03-31 | 0.0888469| 0.3566318| 0.2459911|
|2017-06-30 | 0.8295749| 0.2122948| 0.3502610|
|2017-07-25 | 0.8999987| 0.3771964| 0.9212028|

This function is obviously more complicated than the script above, but the **field** parameter adds some challenges. I want my data wrangling functions to follow the dplyr convention of passing expressions as field names. This keeps everything consistent. I use the **deparse** function to convert the expression to a string so that I can access the data. I could use lazyeval for this (which is how dplyr works) but it creates many more complications and unatractive code. There are limitations to deparse but they do not impact this function (see [https://cran.r-project.org/web/packages/lazyeval/vignettes/lazyeval.html]).

It would be useful to pass a aggregation function to this function to aggregate by the period (mean, median, max, etc.).  I will create this function in the future, for now I use xts to handle this.
