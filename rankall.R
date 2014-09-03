rankall <- function(outcome, num = "best") {

	data <- read.csv("outcome-of-care-measures.csv",colClasses="character")
	data[,11] <- as.numeric(data[,11])
	data[,17] <- as.numeric(data[,17])
	data[,23] <- as.numeric(data[,23])

	check_outcome <- c("heart attack","heart failure","pneumonia");
	if (is.null(outcome)) {
		stop("Invalid outcome")
	} 
	if (!outcome %in% check_outcome) stop("Invalid outcome")

	state_wise_data <- split(data,data$State)

	if (outcome == "heart attack") {
		outcome_index <- 11
	}
	if (outcome == "heart failure") {
			outcome_index <- 17
	}
	if (outcome == "pneumonia") {
			outcome_index <- 23
	}

	state <- sort(unique(data[,7]))
	num_state <- length(state)

	state_wise_data <- split(data,data$State)

	output <- data.frame(54,2)
	colnames(output) <- c("hospital", "state")
#	rownames(output) <- c(state)

	for (x in 1:num_state) {
		mortality_data <- state_wise_data[[x]][[outcome_index]]
		bad <- is.na(mortality_data)
		mortality_data <- mortality_data[!bad]
	
		hos_name <- state_wise_data[[x]][[2]]
		hos_name <- hos_name[!bad]
	
		num_hos <- length(hos_name)

		index_mortality <- order(mortality_data,hos_name)

		if (class(num)=="numeric" & num > num_hos) {
			output[x,1] <- NA
			output[x,2] <- state[x]
		}
			
		if (num=="best") {
			output[x,1] <- hos_name[index_mortality[1]]
			output[x,2] <- state[x]
		}

		if (num=="worst") {
			output[x,1] <- hos_name[tail(index_mortality,1)]
			output[x,2] <- state[x]
		}

		if (class(num)=="numeric") {
			output[x,1] <- hos_name[index_mortality[num]]
			output[x,2] <- state[x]
		}
	}
	output
}