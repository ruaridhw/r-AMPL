% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ampl.R
\name{read}
\alias{read}
\alias{read_model}
\alias{read_data}
\title{Read}
\usage{
read(ampl, filename, cd = TRUE)

read_model(ampl, filename, cd = TRUE)

read_data(ampl, filename, cd = TRUE)
}
\arguments{
\item{ampl}{\code{amplpy.ampl.AMPL} object}

\item{filename}{Full path to the file.}

\item{cd}{Logical indicating whether to run the file
in its directory to allow for relative path names.
\code{FALSE} will cause AMPL to \code{read} in its current working
directory. Defaults to \code{TRUE}.}
}
\value{
amplpy.ampl.AMPL object
}
\description{
Interprets the specified file.
As a side effect, it invalidates all entities
(as the passed file can contain any arbitrary command);
the lists of entities will be re-populated lazily
(at first access).
}
\details{
\code{read_model} accepts a script or model or mixed.

\code{read_data} accepts an AMPL data file. After reading
the file the interpreter is put back to "model" mode.
}
