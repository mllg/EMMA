#' Perform imputation using MCA, PCA, or FMAD algorithm.
#'
#' @description Function use missMDA package to perform data imputation. Function can found the best number of dimensions for this imputation.
#' User can choose whether to return one imputed dataset or list or imputed datasets form Multiple Imputation.
#' @details Function use different algorithm to adjust for variable types in df. For only numeric data PCA will be used. MCA for only categorical and FMAD for mixed. If optimize==TRUE function will try to find optimal ncp if its not possible default ncp=2 will be used. In some cases ncp=1 will be used if ncp=2 don't work. For multiple imputations, if set ncp don't work error will be return.
#'
#' @param df data.frame. Df to impute with column names and without target column.
#' @param col_type character vector. Vector containing column type names.
#' @param percent_of_missing numeric vector. Vector contatining percent of missing data in columns for example  c(0,1,0,0,11.3,..)
#' @param optimize_ncp logical. If true number of dimensions used to predict the missing entries will be optimized. If False by default ncp = 2 it's used.
#' @param set_ncp intiger >0. Number of dimensions used by algortims. Used only if optimize_ncp = Flase.
#' @param col_0_1 Decaid if add bonus column informing where imputation been done. 0 - value was in dataset, 1 - value was imputed. Default False. (Works only for returning one dataset).
#' @param return_one One or many imputed sets will be returned. Default True.
#' @param random.seed random seed.
#' @param coeff.ridge Value use in Regularized method.
#' @param ncp.max integer corresponding to the maximum number of components to test. Default 5.
#' @param maxiter maximal number of iteration in algortihm.
#' @param method method used in imputation algoritm.
#' @param threshold threshold for convergence.
#' @param out_file  Output log file location if file already exists log message will be added. If NULL no log will be produced.
#' @import missMDA
#'
#' @return Retrun one imputed data.frame if retrun_one=True or list of imputed data.frames if retrun_one=False.
#' @export



missMDA_FMAD_MCA_PCA <- function(df,col_type,percent_of_missing,optimize_ncp=TRUE,set_ncp=2,col_0_1=FALSE,ncp.max=5,return_one = TRUE,random.seed=123,maxiter=998,
                                 coeff.ridge=1,threshold=1e-6,method='Regularized',out_file=NULL){


  if (sum(is.na(df))==0){return(df)}

  #Flags informing about data type
  FMAD <-  FALSE # mix
  MCA <-  FALSE # categorical
  PCA <- FALSE # numeric

  if ('factor' %in% col_type & ( 'numeric' %in%col_type | 'integer' %in%col_type)){FMAD <- TRUE  }
  if ('factor' %in%col_type & !( 'numeric' %in% col_type | 'integer' %in% col_type)){MCA <- TRUE}
  if ( !('factor' %in%col_type) & ( 'numeric' %in%col_type | 'integer' %in%col_type)){PCA <-TRUE }

  if(!is.null(out_file)){

    write('FMAD MCA PCA',file = out_file,append = T)
  }


  tryCatch({
  # If optimize_npc set True
  if (optimize_ncp){
    Fail <- FALSE
    tryCatch({
    if(FMAD){set_ncp <-missMDA::estim_ncpFAMD(df,method = method,ncp.max = ncp.max)$ncp }
    if(MCA){set_ncp <- missMDA::estim_ncpMCA(df,method = method,ncp.max = ncp.max)$ncp}
    if(PCA){set_ncp <- missMDA::estim_ncpPCA(df,method = method,ncp.max = ncp.max)$ncp}
    },error = function(e) { Fail <<- TRUE})
    if (Fail){print('Fail to estimate ncp')

      if(!is.null(out_file)){

        write('Fail to estimate ncp',file = out_file,append = T)
      }}
  }

  if (return_one){
  # imputation
  tryCatch({
  if(FMAD){final <-missMDA::imputeFAMD(df,ncp = set_ncp,method = method,threshold = threshold,maxiter = maxiter,coeff.ridge = coeff.ridge,seed = random.seed)$completeObs }
  if(MCA){final <- missMDA::imputeMCA(df,ncp = set_ncp,method = method,threshold = threshold,maxiter = maxiter,coeff.ridge = coeff.ridge,seed = random.seed)$completeObs}
  if(PCA){final <- missMDA::imputePCA(df,ncp=set_ncp,method = method,threshold = threshold,maxiter = maxiter,coeff.ridge = coeff.ridge,seed = random.seed)$completeObs}
    if(!is.null(out_file)){
      write(paste0('ncp :',set_ncp),file = out_file,append = T)
    }
  },error=function(e){
    if(FMAD){final <-missMDA::imputeFAMD(df,ncp = 1,method = method,threshold = threshold,maxiter = maxiter,coeff.ridge = coeff.ridge,seed = random.seed)$completeObs }
    if(MCA){final <- missMDA::imputeMCA(df,ncp = 1,method = method,threshold = threshold,maxiter = maxiter,coeff.ridge = coeff.ridge,seed = random.seed)$completeObs}
    if(PCA){final <- missMDA::imputePCA(df,ncp=1 ,method = method,threshold = threshold,maxiter = maxiter,coeff.ridge = coeff.ridge,seed = random.seed)$completeObs}
    if(!is.null(out_file)){
      write('ncp:1',file = out_file,append = T)
    }
  })
  if(!is.null(out_file)){
    write('  OK',file = out_file,append = T)
  }

  # adding 0,1 cols
    if (col_0_1){
    columns_with_missing <-  (as.data.frame(is.na(df))*1)[,percent_of_missing>0]
    colnames(columns_with_missing) <- paste(colnames(columns_with_missing),'where',sep='_')
    final <- cbind(final,columns_with_missing)
    }
    for (i in colnames(final)[col_type=='integer']){
      final[,i] <- as.integer(final[,i])
    }

    for (i in colnames(df)[(col_type=='factor')]){

      if(!setequal(as.character(unique(na.omit(df[,i]))),levels(final[,i]))){

        reg_exp <- paste0('.*',i)
        levels(final[,i]) <- substr(sub(reg_exp, "", levels(final[,i])),start = 2,stop = 9999)
      }
    }

    for (i in colnames(df)[(col_type=='factor')]){

      if(!setequal(levels(na.omit(df[,i])),levels(final[,i]))){

        levels(final[,i]) <- c(levels(na.omit(df[,i])))
      }
    }

  return(final)}
  },error=function(e){
    if(!is.null(out_file)){
      write(as.character(e),file = out_file,append = T)
    }
    stop(e)
  })
  if (!return_one){
    if(FMAD){final <-missMDA::MIFAMD(df,ncp = set_ncp)$completeObs }
    if(MCA){final <- missMDA::MIMCA(df,ncp = set_ncp)$completeObs}
    if(PCA){final <- missMDA::MIPCA(df,ncp=set_ncp)$completeObs}
    final <- final$res.MI


    return(final)
  }
}







