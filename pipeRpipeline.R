# source
# https://plus.google.com/u/0/+KunRen/posts/SA2SjHqB6s6

library(pipeR)
library(dplyr)
library(nycflights13)

pipeline({ #this version does not require a pipeline operator
    flights
    group_by(year, month, day)
    select(arr_delay, dep_delay)
    ? summary(.$arr_delay)
    ? summary(.$dep_delay)
    summarise(
        arr = mean(arr_delay, na.rm = TRUE),
        dep = mean(dep_delay, na.rm = TRUE))
    ~ flights_summ
    filter(arr > 30 | dep > 30)
})

This text was recognized by the built-in Ocrad engine. A better transcription may be attained by right clicking on the selection and changing the OCR engine to "Tesseract" (under the "Language" menu). This message can be removed in the future by unchecking "OCR Disclaimer" (under the Options menu). More info: http://projectnaptha.com/ocrad