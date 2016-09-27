---
layout: post
title: "I Hate You Paste!"
categories: [Solutions]
tags: [paste, binary operators]
---


I really don't hate the paste command, it is actually quite useful when working with vectors. I just hate using it for simple string concatenation. 


{% highlight r %}
var = 4.345
paste0("The value is: ", var)
{% endhighlight %}



{% highlight text %}
## [1] "The value is: 4.345"
{% endhighlight %}

Luckily, R has the functionality to create binary operators so I rolled my own string concatenation operator.


{% highlight r %}
"%+%" = function(...) {paste0(...)}

"The value is: " %+% var
{% endhighlight %}



{% highlight text %}
## [1] "The value is: 4.345"
{% endhighlight %}
