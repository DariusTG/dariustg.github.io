---
layout: post
title: "I Hate You paste!"
subtitle: "Don't call me anymore."
categories: [Solutions]
tags: [paste, binary operators]
images:
  - url: /img/posts/paste.png
    alt: paste
    title: I Hate You paste!
---


I really don't hate the paste function, it is actually quite useful when working with vectors. I just hate using it for simple string concatenation. 

{% assign image = page.images[0] %}
{% include image.html image=image %}


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
