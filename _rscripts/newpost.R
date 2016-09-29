NewPost = function(title) {
  
  r = httr::POST("http://slugify.net/get-slug", body = list(string = title))
  slug = httr::content(r, as = "text")
  
  rmarkdown::draft("_source/" %+% Sys.Date() %+% "-" %+% slug, "_templates/post", create_dir = F, edit = T)
}

