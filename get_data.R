## Get Data

if (!dir.exists("data")) {
  dir.create("data")  
}

if (!file.exists("data/Coursera-SwiftKey.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",
                "data/Coursera-SwiftKey.zip")
}
  
if (!dir.exists("data/Coursera-SwiftKey")) {
  unzip("data/Coursera-SwiftKey.zip",exdir = "data/Coursera-SwiftKey")
}
