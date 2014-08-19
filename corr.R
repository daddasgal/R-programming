## Function corr() takes a directory of data files and a threshold for completely observed cases (on all variables) as its arguments. 
## It calculates the correlation between sulfate and nitrate for monitor locations where the number of complete cases is greater than the threshold. 
## The function returns a vector of correlations for the monitors that meet the threshold requirement. 
## If no monitors meet the requirement, it returns a numeric vector of length 0.

corr <- function(directory = "specdata", threshold = 0) {
		
	nobs <- complete("specdata", 1:332)$nobs
	file_list <- list.files("specdata", full.names=TRUE)
	x <- 1
	corr <- vector()
	for (i in 1:length(nobs)) {
		if (nobs[i] > threshold)	{
			read_file <- read.csv(file_list[i])
			nas <- complete.cases(read_file)
			good_file <- read_file[nas,]			
			corr[x] <- cor(good_file$sulfate,good_file$nitrate)
			x <- x + 1
		end
		}
	}
	if (length(corr)==0) {
		corr <- vector('numeric')
		return
	}
	corr
}
