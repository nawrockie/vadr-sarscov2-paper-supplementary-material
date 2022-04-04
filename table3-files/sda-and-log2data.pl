my $usage = "perl sda-and-log2data.pl <category e.g. emb.nov21> <sda file> <log file>";

if(scalar(@ARGV) != 3) { 
  die $usage;
}
my ($category, $sda_infile, $log_infile) = (@ARGV);

my $nseq = 0; # total num seqs
my $n1 = 0;
my $sum_seed_fraction = 0.;

open(IN, $sda_infile) || die "ERROR unable to open $sda_infile";
while($line = <IN>) { 
  ## head ../vadr-runs/va-v1p4p1-emb.apr21/*sda
  #seq  seq   seq                     seed  seed seed       5'unaln  5'unaln   5'unaln     3'unaln   3'unaln   3'unaln
  #idx  name  len  model      p/f     seq   mdl  fraction   seq      mdl       fraction        seq       mdl  fraction
  #1     gi|2031810528|emb|OD921535.1|  29884  NC_045512  PASS                 1..11287:+,11288..21755:+,21756..21975:+,21976..28252:+,28253..29884:+                 1..11287:+,11297..21764:+,21771..21990:+,21994..28270:+,28272..29903:+     1.000        -        -         -               -               -         -
  if($line !~ m/^\#/) { 
    chomp $line;
    my @el_A = split(/\s+/, $line);
    if(scalar(@el_A) == 14) { 
##############
# to use seed_fraction column (which is rounded to 3 sig digits, so may be 1.000 even if complete seq is not covered by seed
# Example:
#seq  seq                              seq                         seed         seed      seed   5'unaln    5'unaln   5'unaln         3'unaln         3'unaln   3'unaln
#idx  name                             len  model      p/f          seq          mdl  fraction       seq        mdl  fraction             seq             mdl  fraction
#---  -----------------------------  -----  ---------  ----  ----------  -----------  --------  --------  ---------  --------  --------------  --------------  --------
#8     gi|1946391892|emb|LR962907.1|  29839  NC_045512  PASS  1..29836:+  31..29866:+     1.000         -          -         -  29737..29839:+  29767..29869:+     0.003
#
#      my ($seed_fraction) = $el_A[7];
#      $sum_seed_fraction += $seed_fraction;
#      if($seed_fraction eq "1.000") { 
#        $n1++;
#      }
##############
      my $seq_length  = $el_A[2];
      my $seed_coords = $el_A[5];
      $tot_seq_nt  += $seq_length;
      if($seed_coords eq "-") { 
        # skip this sequence, no seed, maybe NO_ANNOTATION, we still count it towards average seed fraction
      }
      else { 
#      my $seed_length = local_vdr_CoordsLength($seed_coords, undef); # inserts w.r.t model are not included in the seed coords
        my $seed_length = abs(local_vdr_Feature3pMostPosition($seed_coords, undef) - local_vdr_Feature5pMostPosition($seed_coords, undef)) + 1;
        $tot_seed_nt += $seed_length;
        if($seed_length == $seq_length) { 
          $n1++; 
        }
#      else { 
#        printf("HEYA $el_A[1] seq_length: $seq_length seed_coords: $seed_coords seed_length: $seed_length seed_fraction: $el_A[7]\n");
#        print $line . "\n";
#      }
      }
      $nseq++;
    }
    else { 
      die "ERROR unable to parse line $line";
    }
  }
}
close(IN);

open(IN, $log_infile) || die "ERROR unable to open $log_infile";
my $tot_secs = undef;
## Elapsed time:  00:30:01.13
while($line = <IN>) { 
  if($line =~ m/^\# Elapsed time:\s+(\S+)/) { 
    if(defined $tot_secs) { 
      die "ERROR read elapsed time twice";
    }
    my $time = $1;
    ($hours, $minutes, $seconds) = split(":", $time);
    $tot_secs += 3600 * $hours;
    $tot_secs += 60 * $minutes;
    $tot_secs += $seconds;
  }
}
close(IN);
if(! defined $tot_secs) { 
  die "ERROR didn't read elapsed time"
}

printf("$category avgseedfract %.5f\n", $tot_seed_nt / $tot_seq_nt);
printf("$category fullseedfract %.5f\n", $n1 / $nseq);
printf("$category secperseq %.5f\n", $tot_secs / $nseq);


#################################################################
# Subroutine: local_vdr_CoordsLength()
# Incept:     EPN, Tue Mar 26 05:56:08 2019
#
# Synopsis: Given a comma separated coords string, parse it, 
#           validate it, and return its length.
# 
# Arguments:
#  $coords:  coordinate string
#  $FH_HR:   REF to hash of file handles, including "log" and "cmd"
#
# Returns:   total length of segments in $coords
#
# Dies: if unable to parse $coords
#
#################################################################
sub local_vdr_CoordsLength {
  my $sub_name = "vdr_CoordsLength";
  my $nargs_expected = 2;
  if(scalar(@_) != $nargs_expected) { printf STDERR ("ERROR, $sub_name entered with %d != %d input arguments.\n", scalar(@_), $nargs_expected); exit(1); } 

  my ($coords, $FH_HR) = @_;
  if(! defined $coords) { 
    #ofile_FAIL("ERROR in $sub_name, coords is undefined", 1, $FH_HR); 
    die "ERROR in $sub_name, coords is undefined";
  }

  # if there's no comma, we should have a single span
  if($coords !~ m/\,/) { 
    my ($start, $stop, undef) = local_vdr_CoordsSegmentParse($coords, $FH_HR);
    return abs($start - $stop) + 1;
  }
  # else, split it up and sum length of all
  my @coords_A  = split(",", $coords);
  my ($start, $stop);
  my $ret_len = 0;
  foreach my $coords_tok (@coords_A) { 
    ($start, $stop, undef) = local_vdr_CoordsSegmentParse($coords_tok, $FH_HR);
    $ret_len += abs($start - $stop) + 1;
  }

  return $ret_len;
}

#################################################################
# Subroutine: local_vdr_CoordsSegmentParse()
# Incept:     EPN, Tue Mar 26 06:15:09 2019
#
# Synopsis: Given a single coords token, validate it, 
#           and return its start, stop, strand values.
# 
# Arguments:
#  $coords_tok:   coordinate token
#  $FH_HR:        REF to hash of file handles, including "log" and "cmd"
#
# Returns:    3 values:
#             $start:  start position
#             $stop:   stop position
#             $strand: strand
#
# Dies: if unable to parse $coords
#
#################################################################
sub local_vdr_CoordsSegmentParse {
  my $sub_name = "local_vdr_CoordsSegmentParse";
  my $nargs_expected = 2;
  if(scalar(@_) != $nargs_expected) { printf STDERR ("ERROR, $sub_name entered with %d != %d input arguments.\n", scalar(@_), $nargs_expected); exit(1); } 

  my ($coords_tok, $FH_HR) = @_;
  if(! defined $coords_tok) { 
    #ofile_FAIL("ERROR in $sub_name, coords is undefined", 1, $FH_HR); 
    die "ERROR in $sub_name, coords is undefined";
  }
  if($coords_tok =~ /^\<?(\d+)\.\.\>?(\d+)\:([\+\-])$/) { 
    return ($1, $2, $3);
  }
  #ofile_FAIL("ERROR in $sub_name, unable to parse coords token $coords_tok", 1, $FH_HR); 
  die "ERROR in $sub_name, unable to parse coords token $coords_tok";

  return; # NEVER REACHED
}

#################################################################
# Subroutine: local_vdr_Feature5pMostPosition()
# Incept:      EPN, Fri Mar  8 12:57:21 2019
#
# Purpose:    Return 5'-most position in all segments for a feature.
#
# Arguments: 
#  $coords:  coords value from feature info
#  $FH_HR:   ref to hash of file handles
# 
# Returns:   5'-most position
#
# Dies:      if $coords is not parseable.
#
################################################################# 
sub local_vdr_Feature5pMostPosition { 
  my $sub_name = "local_vdr_Feature5pMostPosition";
  my $nargs_exp = 2;
  if(scalar(@_) != $nargs_exp) { die "ERROR $sub_name entered with wrong number of input args"; }

  my ($coords, $FH_HR) = @_;
  
  if($coords =~ /^(\d+)\.\.\d+/) { 
    return $1;
  }
  else { 
    #ofile_FAIL("ERROR in $sub_name, unable to parse ftr_info_HA coords string " . $coords, 1, $FH_HR); 
    die "ERROR in $sub_name, unable to parse ftr_info_HA coords string $coords";
  }

  return; # NEVER REACHED
}

#################################################################
# Subroutine: local_vdr_Feature3pMostPosition()
# Incept:      EPN, Fri Mar  8 13:00:31 2019
#
# Purpose:    Return 3'-most position in all segments for a feature.
#
# Arguments: 
#  $coords:  coords value from feature info
#  $FH_HR:   ref to hash of file handles
# 
# Returns:   3'-most position
#
# Dies:      if $coords is not parseable.
#
################################################################# 
sub local_vdr_Feature3pMostPosition { 
  my $sub_name = "local_vdr_Feature3pMostPosition";
  my $nargs_exp = 2;
  if(scalar(@_) != $nargs_exp) { die "ERROR $sub_name entered with wrong number of input args"; }

  my ($coords, $FH_HR) = @_;
  
  if($coords =~ /\d+\.\.(\d+)\:[\+\-]$/) { 
    return $1;
  }
  else { 
    #ofile_FAIL("ERROR in $sub_name, unable to parse ftr_info_HA coords string " . $coords, 1, $FH_HR); 
    die "ERROR in $sub_name, unable to parse ftr_info_HA coords string $coords";
  }

  return; # NEVER REACHED
}
