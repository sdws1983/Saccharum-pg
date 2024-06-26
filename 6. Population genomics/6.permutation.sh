for i in `seq 1 50000`;do
fgrep -w -f <(shuf -n 2610 Srufi.geneid) ../Srufi.BTx623.last.filtered.trans.one2one | fgrep -w -f <(shuf -n 3896 BTx623.geneid) - |wc -l # IS-Wild 232
done
