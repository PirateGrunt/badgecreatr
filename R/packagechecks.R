## package checks
# 
# 
### put badges in readme function

#' Place badges inside readme file
#' 
#' This is the main function to add badges to your readme.
#'
#' @param location folder where readme.rmd resides
#' @param status one of: "concept", "wip", "suspended", "abandoned", "active", "inactive",  or "unsupported"
#' @param githubaccount your githubname
#' @param githubrepo your githubrepositoryname
#' @param branch master, develop, etc.
#'
#' @return readme file with added badges
#' @export
#'
badgeplacer <- function(location = ".", status = "active",  
                        githubaccount = "search", githubrepo = "search", 
                        branch = "master"){
    badge_result <-findbadges(location)
    if(sum(sapply(badge_result, length))==0){message("no badges found in readme.")}
    #account <- githubcredentials(account = githubaccount,repo = githubrepo,
                               #  branch = branch)
    readme <- readLines(file.path(location,"README.Rmd" ))
    # find yaml top content
    if(length(grep("---", readme))<2){stop("no top yaml at readme.Rmd")}
    bottomyaml <- grep("---", readme)[2]
    # action based on bagdge_result
    #if(length(sapply(bagdge_result, length))==0){
        readme <- append(readme, c(
            if(!badge_result$projectstatus_readme){
                projectstatusbadge(status)
            },
            if(!badge_result$licencebadge_readme){
                                       licbadgebuilder(badge_result$licence)   
            },
             if(!badge_result$travisbadge_readme){
                 if(badge_result$travisfile){
                     travisbadge(
                                 ghaccount = githubaccount, 
                                 ghrepo = githubrepo ,
                                 branch = branch)
                 }else message("No .travis.yml file was found, no travis badge will be created")
                                        
            },
            if(!badge_result$codecoverage_readme){
                if(badge_result$codecov_in_travisfile){
                    codecovbadge(ghaccount = githubaccount, 
                                 ghrepo = githubrepo ,
                                 branch = branch)
                }else message("There was no .travis.yml or no codecov was set up in travis, no codecovbadge created")
                                       
            },
            " ",
            "---",
            " ",
            if(!badge_result$rversion_readme){
                minimal_r_version_badge(badge_result$R_version)
            },
            if(!badge_result$cranbadge_readme){
                cranbadge(badge_result$packagename)      
            },
             if(!badge_result$packageversionbadge_readme){
                 packageversionbadge(badge_result$packageversion) 
             } ,
            " ",
            "---",
            " ",
            if(!badge_result$last_change_readme)last_change_badge()
                                   ), 
                         bottomyaml)
        

    writeLines(readme, con = file.path(location,"README.Rmd" ))
    message("badges placed at top of readme.rmd document")
}


