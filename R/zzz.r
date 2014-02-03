# Copyright (C) Tal Galili
#
# This file is part of dendextendRcpp.
#
# dendextend is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# dendextend is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/
#


# get("old_get_branches_heights", envir = asNamespace("dendextend"), inherits = T)
# dendextend:::old_get_branches_heights
# dendextendRcpp:::old_get_branches_heights
# sys.frames(asNamespace("dendextend"))
# 
# environment(old_get_branches_heights)=as.environment("package:dendextendRcpp")
# dendextendRcpp:::old_get_branches_heights

assign_dendextendRcpp_to_dendextend <- function() {
   # assigns the FASTER dendextendRcpp functions to override
   # the dendextend functions....
   
   if(suppressWarnings(require(dendextend))) {
      # This wouldn't work since it will only assign
      # the faster function in the current env      
      #       get_branches_heights <- dendextendRcpp::get_branches_heights
      #       heights_per_k.dendrogram <- dendextendRcpp::heights_per_k.dendrogram
      # for getting the functions "into" dendextend, we need to run this:
      
      # create a backup of these functions in order to later
      # compare them using benchmark (their kept invisible - but can be accessed)
      assign("old_get_branches_heights", get_branches_heights, pos=as.environment("package:dendextendRcpp"))
      assign("old_heights_per_k.dendrogram", heights_per_k.dendrogram, pos=as.environment("package:dendextendRcpp"))
      assign("old_cut_lower_fun", cut_lower_fun, pos=as.environment("package:dendextendRcpp"))

      # Using this:
      # assign("old_cut_lower_fun", dendextend::cut_lower_fun, envir=as.environment("package:dendextendRcpp"))
      # makes it impossible to lose the <environment: namespace:dendextend>
      # While it is actually NOT available through namespace:dendextend!!!
      # I guess it is a bug (maybe).

# 
# environment(old_cut_lower_fun)=.GlobalEnv
# 
#    as.environment("package:dendextendRcpp")
# dendextendRcpp::old_cut_lower_fun
# old_cut_lower_fun

      # require(utils) # doesn't help really...
      # but this does: (!)
      # http://stackoverflow.com/questions/13595145/overriding-a-package-function-inherited-by-another-package
      # 	  get("assignInNamespace", envir=asNamespace("utils"))
      # Using only "::" instead of ":::" will crash many tests...
      
      assignInNamespace(
         x= "get_branches_heights",
         value = dendextendRcpp:::get_branches_heights,
         ns = "dendextend"
      )   
      assignInNamespace(
         x= "heights_per_k.dendrogram",
         value = dendextendRcpp:::heights_per_k.dendrogram,
         ns = "dendextend"
      )
      assignInNamespace(
         x= "cut_lower_fun",
         value = dendextendRcpp:::cut_lower_fun,
         ns = "dendextend"
      )
      
# dendextend:::cut_lower_fun
# Good! this works...

      ## p.s:
      # doing the following is a BAD IDEA!
      # This will not allow us to use labels.dendrogram when our Rcpp version fails...
      # assignInNamespace(
      #    x= "labels.dendrogram",
      #    value = dendextendRcpp:::labels.dendrogram,
      #    ns = "stats"
      #    )
      
      
      
   } else {
#       warning("
#               The 'dendextend' package runs 
#               MUCH faster when you also have the dendextendRcpp package installed.
#               Please consider running:
#               install.packages('dendextendRcpp')
#               and then re-load dendextend.
#               ")
   }
   
   }





.onLoad <- function(libname, pkgname){
   # Thanks for Romain: http://stackoverflow.com/questions/4369334/first-lib-idiom-in-r-packages
   
   # adding and removing menus from the Rgui when loading and detaching the library
   # setHook(packageEvent("installr", "attach"), {function(pkgname, libpath) {add.installr.GUI()}  } )
   # setHook(packageEvent("installr", "detach"), {function(pkgname, libpath) {remove.installr.GUI()}  } )
   
}

# menus are added and removed as needed: !!


.onAttach <- function(lib, pkg,...){
   ####
#    packageStartupMessage(installrWelcomeMessage())  
   
   assign_dendextendRcpp_to_dendextend()
   
   
}


# detach( 'package:dendextendRcpp', unload=TRUE )
# require( 'dendextendRcpp' )