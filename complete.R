## complete() reads a directory full of files and reports the number of completely observed cases in each data file. 
## The function returns a data frame where the first column is the name of the file and the second column is the number of complete cases.

complete <- function(directory = "specdata", id = 1:332) {
			
		file_list <- list.files("specdata", full.names=TRUE)
		nob <- matrix()
		for (i in 1:length(id)) {
			read_file <- read.csv(file_list[id[i]])
			row_num <- nrow(read_file)
			count <- 0
			for (j in 1:row_num) {
				if (is.na(read_file$sulfate[j]) == F & is.na(read_file$nitrate[j]) == F)
					count <- count + 1
				end
			end
			}
			nob [i] <- count
			end
		}
		data.frame(id, nobs = nob)
}


