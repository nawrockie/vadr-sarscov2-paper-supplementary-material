$n = 0;
$sum = 0.;
while($line = <>) { 
  chomp $line;
  if($line !~ m/^\#/) { 
    @el_A = split(/\s+/, $line);
    $nid = $el_A[3];
    $denomid = $el_A[4];
    $sum += $nid / $denomid;
    $n++;
  }
}
printf("%.5f\n", $sum/$n);
