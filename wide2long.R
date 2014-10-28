
# R: A convenient way to transform a wide data frame (containing repeated measures)
# into a long data frame ready for an analysis - part 1: "wide2long" function
# by Pawel Kobylinski
# http://www.k0110.com/2014/10/r-convenient-way-to-transform-wide-data_20.html
# 2014-10-20

# ---------------------------------------------------------------------------------
# create example dataframe

data.wide <- cbind(
    as.data.frame(cbind(
        1:12
        ,c(rep("a", 6), rep("A", 6))
        ,c(rep("b", 3), rep("B", 3))
    ))
    ,as.data.frame(cbind(
        c(1:4, NA, 6:12)
        ,c(2:10, NA, 12:13)
        ,22:11
    ))
)
names(data.wide) <- c(
    "id"
    ,"groups.I"
    ,"groups.II"
    ,"dep.var_morning"
    ,"dep.var_evening"
    ,"another.dep.var"
)

data.wide

# ---------------------------------------------------------------------------------

install.packages("reshape2")

# ---------------------------------------------------------------------------------
# the function itself

wide2long <- function(
    data.wf
    ,id.name
    ,within.names
    ,between.names=NULL
    ,dependent.names=NULL
    ,del.miss.casewise=F
    ,measurement2factor=F
    ,measurement.name="measurement"
    ,suffix.divider="_"
){
    require(reshape2)
    if(del.miss.casewise==T){
        data.wf <- data.wf[intersect(
            names(data.wf)
            ,c(
                id.name
                ,within.names
                ,between.names
                ,dependent.names        
            )
        )]
        data.wf <- na.omit(data.wf)
    }
    data.lf <- melt(
        data.wf
        ,id.vars=c(id.name, between.names, dependent.names)
        ,measure.vars=within.names
    )
    data.lf <- cbind(
        data.lf
        ,colsplit(
            data.lf[,"variable"]
            ,pattern=suffix.divider
            ,names=c("indicator", measurement.name)
        )
    )
    data.lf <- cbind(
        subset(data.lf, select=-c(variable, value))
        ,data.lf["value"]
    )
    names(data.lf)[grep("value", names(data.lf))] <- data.lf[1,"indicator"]
    data.lf <- subset(data.lf, select=-indicator)
    if(measurement2factor){
        data.lf[,measurement.name] <- as.factor(data.lf[,measurement.name])
    }
    return(data.lf)
}

# ---------------------------------------------------------------------------------

data.long <- wide2long(
    data.wf=data.wide
    ,id.name="id"
    ,within.names=c("dep.var_morning", "dep.var_evening")
    ,between.names=c("groups.I", "groups.II")
    ,dependent.names="another.dep.var"
    ,measurement.name="time.of.day"
)

data.long

# “data.long” represents exactly the same data that “data.wide” does. But now the independent within-object/within-subject/within-group variable is represented by one and only column, named explicitly “time.of.day”. This name is given arbitrarily with the use of the “measurement.name” parameter of the “wide2long” function. The “morning” and “evening” levels/conditions of the “time.of.day” variable are automatically named after the suffixes of the original “dep.var_morning” and “dep.var_evening” variables. This is one of the functionalities added by me over the original “melt” function from “reshape2” package. You need to pay special attention to the suffix divider. As you can see, the “wide2long” function uses the “_” suffix divider by default, but you can set almost any other suffix divider by means of the “suffix.divider” parameter. Your original wide within-whatever variable names have to be build with suffix dividers and suffixes.

# Casewise/listwise deletion of missing data is another functionality added here (by means of the “del.miss.casewise” parameter). Believe me, it will ease your life when you input your long data frame into the “ezANOVA” function of the “ez” package. Also, the “wide2long” function allows you to decide whether you want the within-whatever variable transformed to a factor or kept as string vector (the “measurement2factor” parameter):

data.long <- wide2long(
    data.wf=data.wide
    ,id.name="id"
    ,within.names=c("dep.var_morning", "dep.var_evening")
    ,between.names=c("groups.I", "groups.II")
    ,dependent.names="another.dep.var"
    ,measurement.name="time.of.day"
    ,del.miss.casewise=TRUE
    ,measurement2factor=TRUE
)

data.long