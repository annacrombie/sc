def fromsctime: .|strptime("%Y/%m/%d %H:%M:%S %z");
def sctimestamp: .|fromsctime|strftime("%s");
def lim: [.|if $limit == "" then .[] else .[0:($limit|tonumber)][] end];
