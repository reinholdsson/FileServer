# R File Server

Created and maintained by Thomas Reinholdsson <reinholdsson@gmail.com>

## Install

    devtools::install_bitbucket("FileServer", "reinholdsson")

## Config

A FileServer primarily needs a config-file, e.g. `config.yml`. It should be an `YAML`-file with a list of all service names followed by some arguments. For example:

    Get custom plot:
      file: functions/plot.r
      output: plot.pdf
      form: forms/plot.yml
    Get mtcars dataset:
      file: functions/mtcars.r
      output: mtcars.csv

Further explanation of the available arguments:

`file`: Path of the function file, which has a structure as follows:

    function(input, output) {
      ...
    }

where `input` contain the user inputs from the form and `output` is the output file object.

`output`: Filename of the output.

`form`: A form that is shown in front of the user, which makes it possible to send input values to the function. E.g.

    Title:
      - Plot 1
      - Plot 2
      - Plot 3
    What is the subtitle?:

`help`: Help text under the select input

`readme`: Readme file path (.md)

## Start file server

    library(FileServer)
    FileServer("config.yml")

##  REST API

Set default values within the url:

    http://localhost:8100/?q=Plot%20Chart&Title=Plot%203

- `TODO`: Add auto-submit through url (e.g. url...?download=1)

## See also

- [FastRWeb](http://www.rforge.net/FastRWeb/)
- [Shiny](http://www.rstudio.com/shiny/)
