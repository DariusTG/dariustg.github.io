---
layout: post
title: "Lightweight Timer Using a Closure"
subtitle: "Your very own swiss chronograph"
categories: [Solutions]
tags: [closures, benchmark, R6]
images:
  - url: /img/chrono.png
    alt: Chronograph
    title: Lightweight Timer Using a Closure
---

I am always looking for a way to speed up processing in R before giving up and porting to C++. 

{% assign image = page.images[0] %}
{% include image.html image=image %}

To find bottlenecks, I used to put timing variables all over code with print statements. When I discovered [R6](https://github.com/wch/R6), I immediately created my own timing class to handle this.


{% highlight r %}
library(magrittr)
library(R6)
Timer = R6Class("Timer",
  ## Public Scope
  public=list(
    initialize = function() {
      # Initialized the timer
      #  and start the clock
      private$ptm = proc.time()
    },
    Lap = function() {
      dif = proc.time() - private$ptm
      private$ptm <<- proc.time()
      print(dif)
    }
  ),
  ## Private Scope
  private=list(
    ptm = NULL
  )
)

t = Timer$new()
for(i in 1:100000) x = i
t$Lap()
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.013   0.006   0.027
{% endhighlight %}



{% highlight r %}
for(i in 1:200000) x = i
t$Lap()
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.030   0.004   0.031
{% endhighlight %}

This works great and I love working with R6, but I want something a little more lightweight for when I'm bouncing between multiple R environments. After racking my brain a little, I found that closures provide great solution to such a simple problem. The closure gives us the data persistance we need and doesn't require outside packages.


{% highlight r %}
Timer = function() {
  # Initialized the timer
  #  and start the clock
  ptm = proc.time()
  
  function(lab = NULL) {
    dif = proc.time() - ptm
    ptm <<- proc.time()
    print(dif)
  }
}

t = Timer()

rst = c()
for(i in 1:10000) {
  test = c()
  for(j in 1:100) {
    test = c(test, sample(1:0, 1))
  }
  rst = c(rst, sum(test))
}
t()
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   5.116   0.000   5.123
{% endhighlight %}



{% highlight r %}
rst = c()
for(i in 1:10000) {
  rst = c(rst, sum(sample(1:0, 100, replace=T)))
}
t()
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.230   0.000   0.231
{% endhighlight %}



{% highlight r %}
rst = matrix(nrow = 10000) %>%
  apply(1, FUN = function(x) sum(sample(1:0, 100, replace=T)))
t()
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.104   0.000   0.102
{% endhighlight %}

You could extend this timer to make fancy output and also put conditional development environment checking. If you really wanted to get sophisticated, you could inject the timer into functions automatically. I may write a post in the future on how to do this. Sounds like fun.

