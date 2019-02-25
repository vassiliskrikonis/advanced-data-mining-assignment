FROM ubuntu:14.04
WORKDIR /yap
RUN apt-get update && apt-get install -y yap wget zip
RUN wget https://github.com/aartikis/RTEC/archive/dsc-msc.zip \
  && unzip dsc-msc.zip
WORKDIR RTEC-dsc-msc/examples/maritime
COPY ["CE patterns/", "CE patterns/"]
COPY ["execution scripts/", "execution scripts/"]
