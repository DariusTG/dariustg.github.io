Timer = function() {
  # Initialized the timer
  #  and start the clock
  ptm = proc.time()
  
  function(lab = NULL) {
    dif = proc.time() - ptm
    print("#--------------#")
    print("#    TIMER     #")
    print("#--------------#")
    if(!is.null(lab)) {
      print(lab)
    }
    ptm <<- proc.time()
    print(dif)
  }
}


(function() {
# This will start the timer and give us 
#  a function to use for checking
#  intervals
t = Timer()

rst = c()
for(i in 1:10000) {
  test = c()
  for(j in 1:100) {
    test = c(test, sample(1:0, 1))
  }
  rst = c(rst, sum(test))
}
t("Double Loop")

rst = c()
for(i in 1:10000) {
  rst = c(rst, sum(sample(1:0, 100, replace=T)))
}
t("Single Loop")

rst = matrix(nrow = 10000) %>%
  apply(1, FUN = function(x) sum(sample(1:0, 100, replace=T)))
t("Vectorized")


})()