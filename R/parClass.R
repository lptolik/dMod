## Methods for the class parlist -----------------------------------------------


#' @export
summary.parlist <- function(x) {
  # Statistics
  m_stat <- stat.parlist(x)
  m_error <- sum(m_stat == "error")
  m_converged <- sum(m_stat == "converged")
  m_notConverged <- sum(m_stat == "notconverged")
  m_sumStatus <- sum(m_error, m_converged, m_notConverged)
  m_total <- length(m_stat)
  
  # Best and worst fit
  m_parframe <- as.parframe(x)
  m_order <- order(m_parframe$value)
  m_bestWorst <- m_parframe[c(m_order[1], tail(m_order, 1)),]
  rownames(m_bestWorst) <- c("best", "worst")
  cat("Results of the best and worst fit\n")
  print(m_bestWorst)
  
  cat("\nStatistics of fit outcome",
      "\nFits aborted:       ", m_error,
      "\nFits not converged: ", m_notConverged,
      "\nFits converged:     ", m_converged,
      "\nFits total:         ", m_sumStatus, " [", m_total, "]", sep = "")
}



#' Gather statistics of a fitlist
#' @param x The fitlist
stat.parlist <- function(x) {
  status <- do.call(rbind, lapply(x, function(fit) {
    if (any(names(fit) == "error")) {
      return("error")
    } else {
      if (fit$converged) {
        return("converged")
      } else {
        return("notconverged")
      }
    }
  }))
  
  rownames(status) <- 1:length(status)
  colnames(status) <- "fit status"
  
  return(status)
}


#' @export
as.parframe <- function(x, ...) {
  UseMethod("as.parframe", x)
}

#' @export
as.parframe.parlist <- function(x) {
  m_stat <- stat.parlist(x)
  m_metanames <- c("index", "value", "converged", "iterations")
  m_parframe <- do.call(rbind, lapply(x[m_stat != "error"], function(fit) {
      data.frame(
        index = fit$index,
        value = fit$value,
        converged = fit$converged,
        iterations = fit$iterations,
        as.data.frame(as.list(fit$argument))
      )
  }))
  m_parframe <- parframe(m_parframe, parameters = names(x[[1]]$parinit), metanames = m_metanames)
  
  return(m_parframe)
}



## Methods for the class parvec ------------------------------------------------



#' Pretty printing of parameter transformations, class par
#' 
#' @author Wolfgang Mader, \email{Wolfgang.Mader@@fdm.uni-freiburg.de}
print.parvec <- function(p, ...) {
  
  ## Diese Funktion mergen mit print.eqnvec
  ## Für parvec neue Funktion schreiben
  
  
#   # Assemble parameters
#   hInner <- "Inner"
#   hOuter <- "Outer"
#   arglist <- list(...)
#   if("linewidth" %in% names(arglist)) linewidth <- arglist$linewidth else linewidth <- 79
#   
#   maxNameWidth <- max(nchar(names(equations)), nchar(hInner))  
#   equationWidth <- if (linewidth - maxNameWidth - 3 > 9) linewidth - maxNameWidth -3
#   else 10
#   
#   
#   # Assemble and print parameter transformation table
#   cat("Table of parameter transformations\n")
#   for (i in seq(1, length(equations))) {
#     eq <- strelide(equations[i], equationWidth, where = "right")
#     eqName <- strpad(names(equations[i]), maxNameWidth, where = "left")
#     cat(eqName, " = ", eq, "\n", sep = "")
#     if (!(i %% 10)) {
#       cat("\n")
#     }
#   }
}


#' @export
"[.parvec" <- function(x, ...) {
  out <- unclass(x)[...]
  deriv <- attr(x, "deriv")[..., ]
  parvec(out, deriv = deriv)
  return(out)
}






