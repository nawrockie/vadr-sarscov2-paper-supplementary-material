esearch -db nuccore -query "Norovirus NOT chimeric AND 50:10000[slen]  AND 1950/01/01:2022/1/25[Publication Date]" | efetch -format acc  > noro.all.list
esearch -db nuccore -query "Norovirus NOT chimeric AND 6947:10000[slen] AND 1950/01/01:2022/1/25[Publication Date]" | efetch -format acc > noro.full.list
