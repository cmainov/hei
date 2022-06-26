dr1 <- haven::read_sas( glue::glue( 'fped_dr1tot_{yrs.cycle}.sas7bdat' ) )
dr2 <- haven::read_sas( glue::glue( 'fped_dr2tot_{yrs.cycle}.sas7bdat' ) )


import_fped <- function( yrs.cycle ) { 
  
  import::from('magrittr','%>%')
  
  dr1 <- haven::read_sas( glue::glue( 'fped_dr1tot_{yrs.cycle}.sas7bdat' ) )
  dr2 <- haven::read_sas( glue::glue( 'fped_dr2tot_{yrs.cycle}.sas7bdat' ) )
  keep.dr1 <- c( 1, which( stringr::str_detect( colnames( dr1 ), 'DR1T_' ) ) ) # keep intake columns and SEQN
  keep.dr2 <- c( 1, which( stringr::str_detect( colnames( dr2 ), 'DR2T_' ) ) )
  
  # merge day 1 and day 2 data
  merged.dr <- dplyr::inner_join( dr1[ keep.dr1 ],dr2[ keep.dr2 ], by='SEQN' ) %>%
    dplyr::inner_join( ., dr1[, 1:14 ],by='SEQN' ) # merge in metadata
  
  return(list(dr1, dr2, merged.dr))
}

list.0518 <- lapply( c( '0506', '0708', '0910', '1112', '1314',
                        '1516', '1718'), function( x ) import_fped( x ))
fped.0518 <- do.call( 'rbind', list.0518 ) 

View(list.0518[[1]][[1]])

