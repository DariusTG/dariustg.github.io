Chronograph = function() {

  library(grid)
  radial_grid = function(r=.5, n=13, x=.5, y=.5, lwd=1, col="black", alpha=1) {
    
    g_angle = seq(from=0, to=360, by=360/(n-1))
    g_theta = (g_angle*pi)/180
    g_o = sin(g_theta)*r
    g_a = cos(g_theta)*r
    g_0 = rep(x, times=n)
    g_01 = rep(y, times=n)
    #grid.lines(x=c(g_0, 0-g_a), y=c(g_0, g_o))
    for(i in 1:length(g_0)) {
      grid.lines(x=c(g_0[i], g_a[i]+x), y=c(g_01[i], g_o[i]+y), gp=gpar(col=col, lwd=lwd, lineend="square", alpha=alpha))  
    }
  }
  #png("img/chrono.png", width = 700, height=700)
  grid.newpage()
  center_r = .01
  sweep_gp = gpar(col="#FFFFFF", fill="#FFFFFF", lwd=2.5)
  hands_gp = gpar(col="#839CA5", fill="#839CA5", lwd=15, lineend="square")
  timer_gp = gpar(col="#154890", fill="#154890", lwd=3.)
  
  # Bezel
  grid.circle(r = .45, gp = gpar(lwd=40, col="black"))
  
  # Dial Ticks
  radial_grid(r=.43, lwd=10)
  radial_grid(r=.41, lwd=6, col="white")
  radial_grid(r=.37, lwd=10)
  radial_grid(r=.35, lwd=20, col="white")
  
  # Brand
  grid.text(label = "\\dg", x = .5, y=.80, gp=gpar(col="#00345e", cex=3, fontfamily="HersheySymbol"))
  grid.text(label = "HOMME", x = .5, y=.75, gp=gpar(col="#00345e", cex=2.35, fontface="bold", fontfamily="HersheySerif"))
  grid.text(label = "OFFICIALLY CERTIFIED", x = .5, y=.715, gp=gpar(col="#00345e", cex=.8, fontface="bold", fontfamily="HersheySans"))
  grid.text(label = "COSMOGRAPH", x = .5, y=.695, gp=gpar(col="#00345e", cex=.8, fontface="bold", fontfamily="HersheySans"))
  # Center
  grid.circle(r=.02, gp=sweep_gp)
  
  
  # Subregisters
  #grid.circle(x = .25,r=.15, gp=gpar(lwd=5, col="#8FCDF7", fill="#8FCDF7"))
  col_scale = rev(c("#82c0ea","#75b3dd","#69a7d1","#5c9ac4","#4f8db7","#4280aa","#36749e","#296791","#1c5a84","#03416b"))
  for(i in 10:1) {
    factor = i/10
    col = col_scale[i]
    grid.circle(x = .25,r=.15 * factor, gp=gpar(lwd=5, col=col, fill=col))
  }
  radial_grid(r=.15, x=.25, lwd=.5, col="white", alpha=.5)
  grid.circle(x = .25,r=center_r, gp=sweep_gp)
  grid.lines(x = c(.25, .25), y=c(.5, .64), gp=sweep_gp)
  
  
  for(i in 10:1) {
    factor = i/10
    col = col_scale[i]
    grid.circle(x = .75,r=.15 * factor, gp=gpar(lwd=5, col=col, fill=col))
  }
  radial_grid(r=.15, n=7, x=.75, lwd=.5, col="white", alpha=.5)
  grid.circle(x = .75,r=center_r, gp=sweep_gp)
  grid.lines(x = c(.75, .75), y=c(.5, .64), gp=sweep_gp)
  
  for(i in 10:1) {
    factor = i/10
    col = col_scale[i]
    grid.circle(x = .5, y=.25,r=.15 * factor, gp=gpar(lwd=5, col=col, fill=col))
  }
  radial_grid(r=.15, n=16, x=.5, y=.25, lwd=.5, col="white", alpha=.5)
  grid.circle(x = .5, y=.25, r=center_r, gp=sweep_gp)
  grid.lines(x = c(.5, .5), y=c(.25, .39), gp=sweep_gp)
  
  # Hour Hand
  x=c(.5, .275)
  y=c(.5, .4)
  model = lm(y ~ x)
  lookup = function(model, x) as.numeric(predict(model, data.frame(x=x)))
  grid.lines(x=x, y=y, gp=hands_gp)
  grid.lines(x=c(.5, .55), y=c(.5, lookup(model, .55)), gp=hands_gp)
  grid.lines(x=c(.45, .29), y=c(lookup(model, .45), lookup(model, .29)), gp=gpar(lwd=5, col="white"))
  
  # Minute Hand
  x=c(.5, .55)
  y=c(.5, .84)
  model = lm(y ~ x)
  lookup = function(model, x) as.numeric(predict(model, data.frame(x=x)))
  grid.lines(x=x, y=y, gp=hands_gp)
  grid.lines(x=c(.5, .49), y=c(.5, lookup(model, .49)), gp=hands_gp)
  grid.lines(x=c(.51, .545), y=c(lookup(model, .51), lookup(model, .545)), gp=gpar(lwd=5, col="white"))
  
  
  # Timer
  grid.circle(r=.01, gp=timer_gp)
  grid.lines(x=c(.5, .5), y=c(.40, .89), arrow = arrow(angle = 20, type = "closed"), gp=timer_gp)
  x1 <- c(.5, .48, .48, .5)
  x2 <- c(.5, .52, .52, .5)
  y <- c(.40, .40, .46, .46)
  grid.bezier(x1, y, gp=timer_gp)
  grid.bezier(x2, y, gp=timer_gp)
  #dev.off()

}