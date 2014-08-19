## The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. 
## Given a vector of monitor ID numbers, 'pollutantmean' reads the monitor's particulate matter data from the directory 
## specified in the 'directory' argument and returns the mean of the pollutant across all of the monitors, ignoring any missing values.

pollutantmean <- function(directory = "specdata", pollutant, id = 1:332) {
        
		file_list <- list.files("specdata", full.names=TRUE)
		full_data <- data.frame()
		for (i in id)
			full_data <- rbind(full_data, read.csv(file_list[i]))
		end

		if (pollutant == "sulfate")
			pollutantmean <- mean(full_data$sulfate, na.rm=TRUE)
		else  if (pollutant == "nitrate")
				pollutantmean <- mean(full_data$nitrate, na.rm=TRUE)
			end
		end
		pollutantmean

}