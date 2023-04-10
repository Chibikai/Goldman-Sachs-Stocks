install.packages("tensorflow")
library(tensorflow)
-march=native -mtune=native -O3
Sys.setenv('Intel Core i7'='march=native =-mtune=native -O3')
Sys.setenv('Intel Core i7'='march=native =-mtune=native -O3')
Sys.setenv("Intel Core i7"="-Wl,-rpath,/usr/local/cuda/lib64 -L/usr/local/cuda/lib64 -lcudart")

install_tensorflow(extra_params="--config=opt")

