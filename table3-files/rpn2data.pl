my $usage = "perl rpn2data.pl <category e.g. emb.nov21> <rpn file>";

if(scalar(@ARGV) != 2) { 
  die $usage;
}
my ($category, $rpn_infile) = (@ARGV);

my $nseq = 0;
my $sum_seqlen     = 0.;
my $sum_num_Ns_tot = 0.;
my $sum_num_Ns_rp  = 0.;
my $sum_nregs_tot  = 0.;
my $sum_nregs_rp   = 0.;

open(IN, $rpn_infile) || die "ERROR unable to open $rpn_infile";
while($line = <IN>) { 
  ##head ../vadr-runs/va-v1p4p1-emb.apr21/*rpn
  # 0    1                                2    3          4     5       6       7         8      9
  ##seq  seq                              seq                   num_Ns  num_Ns  fract_Ns  nregs  nregs  nregs    nregs    nregs      nnt      nnt  detail_on_regions[S:seq,M:mdl,D:lendiff,N:#Ns,                
  ##idx  name                             len  model      p/f      tot      rp        rp    tot    int     rp  rp-full  rp-part  rp-full  rp-part  E:#non_N_match_expected,F:flush_direction,R:region_replaced?];
  ##---  -----------------------------  -----  ---------  ----  ------  ------  --------  -----  -----  -----  -------  -------  -------  -------  --------------------------------------------------------------
  #1     gi|2031810528|emb|OD921535.1|  29884  NC_045512  PASS     121     121     1.000      2      0      2        2        0      121        0  [S:1..54,M:1..54,D:0,N:54/54,E:?/?,F:-,R:Y];[S:29818..29884,M:29837..29903,D:0,N:67/67,E:?/?,F:-,R:Y];
  if($line !~ m/^\#/) { 
    chomp $line;
    my @el_A = split(/\s+/, $line);
    if(scalar(@el_A) == 16) { 
      my ($seqlen, $num_Ns_tot, $num_Ns_rp, $nregs_tot, $nregs_rp) = ($el_A[2], $el_A[5], $el_A[6], $el_A[8], $el_A[9]);
      $sum_seqlen     += $seqlen;
      $sum_num_Ns_tot += $num_Ns_tot;
      $sum_num_Ns_rp  += $num_Ns_rp;
      $sum_nregs_tot  += $nregs_tot;
      $sum_nregs_rp   += $nregs_rp;
      $nseq++;
    }
    else { 
      die "ERROR unable to parse line $line";
    }
  }
}
close(IN);

printf("$category testnseq %d\n",                $nseq);
printf("$category avgtotNsperseq %.5f\n",    ($sum_num_Ns_tot / $nseq));
printf("$category avgrpNsperseq %.5f\n",     ($sum_num_Ns_rp  / $nseq));
printf("$category fractrpNsperseq %.5f\n",   ($sum_num_Ns_rp  / $sum_num_Ns_tot));
printf("$category avgtotregsperseq %.5f\n",  ($sum_nregs_tot  / $nseq));
printf("$category avgrpregsperseq %.5f\n",   ($sum_nregs_rp   / $nseq));
printf("$category fractrpregsperseq %.5f\n", ($sum_nregs_rp   / $sum_nregs_tot));
