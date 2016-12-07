quantmod::getSymbols("AAPL", from="1990-01-01")
head(AAPL)
head(AAPL.a <- quantmod::adjustOHLC(AAPL))
head(AAPL.uA <- quantmod::adjustOHLC(AAPL, use.Adjusted=TRUE))

xts2data.frame = function(x) {
  df = data.frame(x=zoo::index(x), zoo::coredata(x))
  # Preserve the column names from the xts object 
  #  and use "Date" as the new column for new date column
  colnames(df) = c("Date", colnames(x))
  return(df)
}


data = merge(HIGH=AAPL.a[,"AAPL.High"], LOW=AAPL.a[,"AAPL.Low"], SAR=TTR::SAR(AAPL.a[,c("AAPL.High", "AAPL.Low")])) %>%
  xts2data.frame() %>%
  dplyr::mutate(DATE = Date) %>%
  dplyr::mutate(SAR = ifelse(SAR > AAPL.a$High, SAR/AAPL.a$High-1, SAR/AAPL.a$Low-1)) %>%
  tidyr::separate(DATE, c("Y", "M", "D")) %>%
  dplyr::mutate(Y = as.numeric(Y)) %>%
  dplyr::mutate(IDCHG = )
  #dplyr::filter(Y > 2015)

ggplot(data, aes(x=Date)) +
  geom_line(aes(y=AAPL.High), color="blue") +
  geom_line(aes(y=AAPL.Low), color="blue") +
  geom_line(aes(y=SAR), color="red") +
  scale_y_log10()
# TTR::MACD(AAPL.a$AAPL.Adjusted)
# TTR::runSD(AAPL.a$AAPL.Adjusted, 30)
# TTR::ATR(AAPL.a[,c("AAPL.High", "AAPL.Low", "AAPL.Close")])


TTR::MACD(AAPL.a$AAPL.Adjusted)



ggplot(data, aes(x=Date)) %>%
  geom_line.A(aes(y=AAPL.High), color="blue")




