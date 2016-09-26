---
layout: post
title:  "Serve Jekyll Websites with servr and knitr"
categories: [jekyll, rstats]
tags: [knitr, servr, httpuv, websocket]
---

The R package [**servr**](https://github.com/yihui/servr) can be used to set up an HTTP server to serve files under a directory. Since **servr** v0.2, it has added a function `servr::jekyll()` specifically designed for websites based on Jekyll and R Markdown. The main features of this function are: 

1. R Markdown source files are re-compiled through [**knitr**](http://yihui.name/knitr) when their corresponding Markdown output files become older[^1] than source files;
1. The web page will refresh itself automatically in the above case as well;
 
[^1]: Determined by the modification time of files, i.e., `file.info(x)[, 'mtime']`.

As a result, all you need to do is write your blog posts (R Markdown documents), and you do not need to worry about re-building the website or calling **knitr** commands. Whenever you save a blog post in your text editor, the web page will be updated on the fly. This is particularly handy in the [RStudio IDE](http://www.rstudio.com), because after you run `servr::jekyll()` in the console, you can start writing or editing your R Markdown posts, and the HTML output, displayed in the RStudio viewer pane, will be in sync with your source post in the source panel (see the screenshot below).

[![Jekyll with servr and knitr](http://i.imgur.com/gKVGhiP.png)](http://i.imgur.com/gKVGhiP.png)

## Prerequisites

You must have installed the packages **servr** (>= 0.2) and **knitr** (>= 1.8).


{% highlight r %}
install.packages(c('servr', 'knitr'), repos = 'http://cran.rstudio.com')
{% endhighlight %}

Of course, you have to install [Jekyll](http://jekyllrb.com) as well. For Windows users, you have to make sure `jekyll` can be found from your environment variable `PATH`, i.e., R can call it via `system('jekyll')`. This is normally not an issue for Linux or Mac OS X users (`gem install jekyll` is enough).

## R code chunks

Now we write some R code chunks in this post. For example,


{% highlight r %}
options(digits = 3)
cat("hello world!")
{% endhighlight %}



{% highlight text %}
## hello world!
{% endhighlight %}



{% highlight r %}
set.seed(123)
(x = rnorm(40) + 10)
{% endhighlight %}



{% highlight text %}
##  [1]  9.44  9.77 11.56 10.07 10.13 11.72 10.46  8.73  9.31  9.55 11.22
## [12] 10.36 10.40 10.11  9.44 11.79 10.50  8.03 10.70  9.53  8.93  9.78
## [23]  8.97  9.27  9.37  8.31 10.84 10.15  8.86 11.25 10.43  9.70 10.90
## [34] 10.88 10.82 10.69 10.55  9.94  9.69  9.62
{% endhighlight %}



{% highlight r %}
# generate a table
knitr::kable(head(mtcars))
{% endhighlight %}



|                  |  mpg| cyl| disp|  hp| drat|   wt| qsec| vs| am| gear| carb|
|:-----------------|----:|---:|----:|---:|----:|----:|----:|--:|--:|----:|----:|
|Mazda RX4         | 21.0|   6|  160| 110| 3.90| 2.62| 16.5|  0|  1|    4|    4|
|Mazda RX4 Wag     | 21.0|   6|  160| 110| 3.90| 2.88| 17.0|  0|  1|    4|    4|
|Datsun 710        | 22.8|   4|  108|  93| 3.85| 2.32| 18.6|  1|  1|    4|    1|
|Hornet 4 Drive    | 21.4|   6|  258| 110| 3.08| 3.21| 19.4|  1|  0|    3|    1|
|Hornet Sportabout | 18.7|   8|  360| 175| 3.15| 3.44| 17.0|  0|  0|    3|    2|
|Valiant           | 18.1|   6|  225| 105| 2.76| 3.46| 20.2|  1|  0|    3|    1|



{% highlight r %}
(function() {
  if (TRUE) 1 + 1  # a boring comment
})()
{% endhighlight %}



{% highlight text %}
## [1] 2
{% endhighlight %}



{% highlight r %}
names(formals(servr::jekyll))  # arguments of the jekyll() function
{% endhighlight %}



{% highlight text %}
## [1] "dir"     "input"   "output"  "script"  "serve"   "command"
## [7] "..."
{% endhighlight %}

Just to test inline R expressions[^2] in **knitr**, we know the first element in `x` (created in the code chunk above) is 9.44. You can certainly draw some graphs as well:

[^2]: The syntax in R Markdown for inline expressions is `` `r code` ``, where `code` is the R expression that you want to evaluate, e.g. `x[1]`.


{% highlight r %}
par(mar = c(4, 4, .1, .1))
plot(cars, pch = 19, col = 'red')  # a scatterplot
{% endhighlight %}

![A scatterplot of the cars data](figure/source/2014-09-28-jekyll-with-knitr/cars-1.png)

## The build script

Zero-configuration is required for `servr::jekyll()` to work on your Jekyll website. However, there is always demand for more control over some options, which can be defined in a custom build script. Here are the arguments of `servr::jekyll()`:



