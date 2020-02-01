require('XLConnect')  # install if necessary

# also install XLConnectJars if not installed as dependency


# read dataframes from Excel spreadsheet

dfFactories <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='A1:A6')
dfWarehouses <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='B1:B11')
dfStores <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='C1:C21')
dfProducts <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='D1:D6')

dfCapacityFW <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='E1:E2')
dfCapacityWS <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='E4:E5')
dfMaxStorage <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='E7:E8')

dfTableRoutesFW <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='G2:J71')
dfTableRoutesWF <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='L2:O202')

dfSupply <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='Q2:T15')
dfDemand <- readWorksheetFromFile('transpStoreBigSheet.xlsx',sheet=1,region='V2:X102')

# Initialize write file
filename <- 'transpStore.dat' # give your file a name
cat('//--------------------------------------------------\n',file=filename)
con <- file(filename) # get connection to file to close later
cat('// transportation file produced by reading \n',file=filename,append=T)
cat('// excel file into R using XLConnect \n',file=filename,append=T)
cat('// and using R commands to output textfile \n',file=filename,append=T)
cat('//--------------------------------------------------\n\n',file=filename,append=T)


# some helper functions for writing in the right formats for .dat file
writeSet <- function( varName, df, filename ){
  cat( varName, file = filename, append = T )
  cat( ' = { ', file = filename, append = T )
  numRows <- dim(df)[1]
  for (j in 1:numRows){
    cat( df[j,1], file = filename, append = T )
    cat( ' ', file = filename, append = T )
  }
  cat('};\n', file = filename, append = T )
}


writeNumber <- function( varName, x, filename ){
  cat( varName, file = filename, append = T)
  cat( ' = ', file = filename, append = T)
  cat( x[1, 1], file = filename, append = T)
  cat( ';\n', file = filename, append = T)
}


writeTuplesTable <- function( varName, df, filename){
  cat( varName, file = filename, append = T)
  cat( ' = {\n', file = filename, append = T)
  numRows <- dim( df )[1]
  for (j in 1:numRows){
    cat(' < ', file = filename, append = T)
    write.table( df[j,], file = filename, append = T, quote = F, sep = ', ', 
                 row.names = F, col.names = F, eol = ' >\n' )
  }
  cat('};\n\n', file = filename, append = T)
}


writeTuplesArray <- function( varName, df, filename){
  cat( varName, file = filename, append = T)
  cat( ' = #[\n', file = filename, append = T)
  numRows <- dim( df )[1]
  numCols <- dim( df )[2]
  tupleLen <- numCols - 1
  for (j in 1:numRows){
    cat(' < ', file = filename, append = T)
    write.table( df[j,1:tupleLen], file = filename, append = T, quote = F, sep = ', ', 
                 row.names = F, col.names = F, eol = ' >: ' )
    cat( df[j,numCols] , file = filename, append = T )
    cat( '\n', file = filename, append = T )
  }
  cat(']#;\n\n', file = filename, append = T)
}


# write file
writeSet('Factories',dfFactories,filename)
writeSet('Warehouses',dfWarehouses,filename)
writeSet('Stores',dfStores,filename)
writeSet('Products',dfProducts,filename)

writeNumber('CapacityFW',dfCapacityFW,filename)
writeNumber('CapacityWS',dfCapacityWS,filename)
writeNumber('MaxStorage',dfMaxStorage,filename)

writeTuplesTable('TableRoutesFW',dfTableRoutesFW,filename)
writeTuplesTable('TableRoutesWF',dfTableRoutesWF,filename)

writeTuplesArray('Supply',dfSupply,filename)
writeTuplesArray('Demand',dfDemand,filename)
close(con) # close connection to file

