Bootstrap = function(dir) {
  nodes = list.files(dir)
  print("#########")
  print(dir)
  print(nodes)
  for(i in 1:length(nodes)) {
    #el = String(dir)$Concat(nodes[i])$Val
    el = paste(dir, nodes[i], sep="")
    #if(String(nodes[i])$Right(2)$Val == ".R") {
    if(substr(nodes[i], nchar(nodes[i])-1, nchar(nodes[i])) == ".R") {
      print(el)
      source(el)
    } else if(substr(nodes[i], nchar(nodes[i])-4, nchar(nodes[i])) == ".robj") {
      print(el)
      ## Do nothing
    } else {
      #RecursiveLoad(String(el)$Concat("/")$Val)
      RecursiveLoad(paste(el, "/", sep=""))
    }
  }
}
Bootstrap("_rscripts/")