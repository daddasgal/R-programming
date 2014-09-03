rankhospital <- function(state, outcome, num = "best") {

	data <- read.csv("outcome-of-care-measures.csv",colClasses="character")
	data[,11] <- as.numeric(data[,11])
	data[,17] <- as.numeric(data[,17])
	data[,23] <- as.numeric(data[,23])

	check_state <- unique(data[,7])
	if (is.null(state)) {
		stop("Invalid state")
	} 
	if (!state %in% check_state) stop("Invalid state")

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
	
	mortality_data <- state_wise_data[[state]][[outcome_index]]
	bad <- is.na(mortality_data)
	mortality_data <- mortality_data[!bad]
	
	hos_name <- state_wise_data[[state]][[2]]
	hos_name <- hos_name[!bad]
	
	num_hos <- length(hos_name)
	if (class(num)=="numeric" & num > num_hos) return(NA)

	index_mortality <- order(mortality_data,hos_name)

	if (num=="best") return(hos_name[index_mortality[1]])
	if (num=="worst") return(hos_name[tail(index_mortality,1)])
	if (class(num)=="numeric") return(hos_name[index_mortality[num]])
}