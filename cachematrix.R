## This program helps to create a special square matrix, compute and cache 
## its inverse


## This function helps create a special matrix that can cache its inverse

makeCacheMatrix <- function(x = matrix()) {
          inv <- NULL
          set_mat <- function(y) {
                  x <<- y
                  inv <<- NULL
          }
          get_mat <- function() x
          set_inv <- function(inv_matrix) inv <<- inv_matrix
          get_inv <- function() inv
          list(set_mat = set_mat, get_mat = get_mat,
               set_inv = set_inv, get_inv = get_inv)
}


## This function computes the inverse of the special matrix created by makeCacheMatrix()
## If the inverse has already been computed, the following program simply retries 
## the inverse from the cache

cacheSolve <- function(x, ...) {
          inv <- x$get_inv()
          if(!is.null(inv)) {
                    message("getting cached data")
                    return(inv)
          }
          data <- x$get_mat()
          inv <- solve(data, ...)
          x$set_inv(inv)
          inv
}
