my $min = 50;
my $numerator = 0;
my $denominator = 0;
while($line = <>) { 
  chomp;
  my(@el_A) = split(/\s+/, $line);
  if(scalar(@el_A) != 2) { 
    die "ERROR not 2 tokens on line $line\n";
  }
  my $max_N = $el_A[1];
  if($max_N >= $min) { 
    $numerator++; 
  }
  $denominator++;
}
printf("%d/%d %.5f have N stretch of at least $min nt\n", $numerator, $denominator, $numerator/$denominator);
 
