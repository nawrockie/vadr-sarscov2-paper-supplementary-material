esearch -db nuccore -query "Dengue NOT chimeric AND 50:11200[slen] AND 1950/01/01:2022/1/25[Publication Date]" | efetch -format acc > dengue.all.list
esearch -db nuccore -query "Dengue NOT chimeric AND 10117:11200[slen] AND 1950/01/01:2022/1/25[Publication Date]" | efetch -format acc > dengue.full.list
