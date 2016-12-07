---
layout: post
title: "Pipe Dream"
subtitle: "Plusses and Arrows and Percents, oh my!."
categories: [Solutions]
tags: [magrittr, ggplot]
images:
  - url: /img/posts/pipes.png
    alt: Pipes
    title: Pipe Dream
---

Do you continually substitute "%>%" for "+" when switching between data wrangling and data visualization? I've got just the solution for you!

{% assign image = page.images[0] %}
{% include image.html image=image %}

Count myself as one of those people that continually use a pipe instead of a plus and vice-verca when I'm writing a lot of code. Sir Hadley has basically shit the door on ever switching ggplot to using magrittr pipes and I don't blame him. But he can't stop me from doing whatever the heck I want.

In the following code, I took the sample ggplot code from the help and modified it to use magrittr.


{% highlight r %}
library(magrittr)
library(ggplot2)
library(dplyr)
geom_point_p = function(p, ...) {
  return(
    p + geom_point(...)
  )
}

geom_errorbar_p = function(p, ...) {
  return(
    p + geom_errorbar(...)
  )
}

df = data.frame(
  gp = factor(rep(letters[1:3], each = 10)),
  y = rnorm(30)
)
ds = plyr::ddply(df, "gp", plyr::summarise, mean = mean(y), sd = sd(y))

# The summary data frame ds is used to plot larger red points on top
# of the raw data. Note that we don't need to supply `data` or `mapping`
# in each layer because the defaults from ggplot() are used.
ggplot(df, aes(gp, y)) %>%
  geom_point_p() %>%
  geom_point_p(data = ds, aes(y = mean), colour = 'red', size = 3)
{% endhighlight %}

![plot of chunk unnamed-chunk-1](https://dariustg.github.io/figure/source/2016-12-07-pipe-dream/unnamed-chunk-1-1.png)

{% highlight r %}
# Same plot as above, declaring only the data frame in ggplot().
# Note how the x and y aesthetics must now be declared in
# each geom_point() layer.
ggplot(df) %>%
  geom_point_p(aes(gp, y)) %>%
  geom_point_p(data = ds, aes(gp, mean), colour = 'red', size = 3)
{% endhighlight %}

![plot of chunk unnamed-chunk-1](https://dariustg.github.io/figure/source/2016-12-07-pipe-dream/unnamed-chunk-1-2.png)

{% highlight r %}
# Alternatively we can fully specify the plot in each layer. This
# is not useful here, but can be more clear when working with complex
# mult-dataset graphics
ggplot() %>%
  geom_point_p(data = df, aes(gp, y)) %>%
  geom_point_p(data = ds, aes(gp, mean), colour = 'red', size = 3) %>%
  geom_errorbar_p(
    data = ds,
    aes(gp, mean, ymin = mean - sd, ymax = mean + sd),
    colour = 'red',
    width = 0.4
  )
{% endhighlight %}

![plot of chunk unnamed-chunk-1](https://dariustg.github.io/figure/source/2016-12-07-pipe-dream/unnamed-chunk-1-3.png)

I may have to roll this into a package at some point.
