% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PipeOpVIM_kNN.R
\name{PipeOpVIM_kNN}
\alias{PipeOpVIM_kNN}
\title{PipeOpVIM_kNN}
\description{
Implements KNN methods as mlr3 pipeline, more about VIM_KNN \code{\link{autotune_VIM_kNN}}.
}
\section{Input and Output Channels}{

Input and output channels are inherited from \code{\link{PipeOpImpute}}.
}

\section{Parameters}{

The parameters include inherited from [`PipeOpImpute`], as well as: \cr
\itemize{
\item \code{id} :: \code{character(1)}\cr
Identifier of resulting object, default \code{"imput_VIM_kNN"}.
\item \code{k} :: \code{intiger(1)}\cr
Threshold for convergence, default \code{5}.
\item \code{numFUN} :: \code{function(){}}\cr
Function for aggregating the k Nearest Neighbours in the case of a numerical variable.  Can be ever function with input=numeric_vector and output=atomic_object, default \code{median}.
\item \code{catFUN} :: \code{function(){}}\cr
Function for aggregating the k Nearest Neighbours in case of categorical variables. It can be any function with input=not_numeric_vector and output=atomic_object, default \code{VIM::maxCat}
\item \code{out_fill} :: \code{character(1)}\cr
Output log file location. If file already exists log message will be added. If NULL no log will be produced, default \code{NULL}.
}
}

\section{Super classes}{
\code{\link[mlr3pipelines:PipeOp]{mlr3pipelines::PipeOp}} -> \code{\link[mlr3pipelines:PipeOpImpute]{mlr3pipelines::PipeOpImpute}} -> \code{VIM_kNN_imputation}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{PipeOpVIM_kNN$new()}}
\item \href{#method-clone}{\code{PipeOpVIM_kNN$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="mlr3pipelines" data-topic="PipeOp" data-id="predict">}\href{../../mlr3pipelines/html/PipeOp.html#method-predict}{\code{mlr3pipelines::PipeOp$predict()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3pipelines" data-topic="PipeOp" data-id="print">}\href{../../mlr3pipelines/html/PipeOp.html#method-print}{\code{mlr3pipelines::PipeOp$print()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3pipelines" data-topic="PipeOp" data-id="train">}\href{../../mlr3pipelines/html/PipeOp.html#method-train}{\code{mlr3pipelines::PipeOp$train()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PipeOpVIM_kNN$new(
  id = "imput_VIM_kNN",
  k = 5,
  numFun = median,
  catFun = VIM::maxCat,
  out_file = NULL
)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PipeOpVIM_kNN$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
