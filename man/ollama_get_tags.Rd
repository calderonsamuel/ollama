% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ollama_get_tags.R
\name{ollama_get_tags}
\alias{ollama_get_tags}
\title{Retrieve tags from a model.}
\usage{
ollama_get_tags(name)
}
\arguments{
\item{name}{The model from which the tags will be retrieved}
}
\value{
A character vector with all the available tags.
}
\description{
This function scrapes the Ollama library page, retrieves information
about available available tags for a specific model, and returns a character
vector with all the tag names.
}
\examples{
\dontrun{
ollama_get_tags("llama2")
ollama_get_tags("mistral")
}

}
