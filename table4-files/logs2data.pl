my $usage = "perl logs2data.pl <category e.g. cpu4-trim.emb.nofeb20> <list of log files>";

if(scalar(@ARGV) != 2) { 
  die $usage;
}
my ($category, $log_list) = (@ARGV);

open(LIST, $log_list) || die "ERROR unable to open $log_list";
my $sum_nseq = 0;
my $sum_secs = 0.;
while(my $log_file = <LIST>) { 
  chomp $log_file;
  open(LOG, $log_file) || die "ERROR unable to open $log_file for reading";
  my $nseq_annot = undef;
  my $nseq_notannot = undef;
  my $tot_secs = undef;
  ## Elapsed time:  00:30:01.13
  while($line = <LOG>) { 
    if($line =~ m/^1\s+NC_045512\s+Sarbecovirus\s+SARS-CoV-2\s+(\d+)/) { 
      #printf("nseq line: $line\n");
      if(defined $nseq_annot) { 
        die "ERROR read nseq twice in $log_file";
      }
      $nseq_annot = $1;
    }
    elsif($line =~ m/^-\s+\*none\*\s+\-\s+\-\s+(\d+)/) { 
      #printf("nseq line: $line\n");
      if(defined $nseq_notannot) { 
        die "ERROR read nseq not annot twice in $log_file";
      }
      $nseq_notannot = $1;
    }
    elsif($line =~ m/^\# Elapsed time:\s+(\S+)/) { 
      #printf("time line: $line\n");
      if(defined $tot_secs) { 
        die "ERROR read elapsed time twice in $log_file";
      }
      my $time = $1;
      ($hours, $minutes, $seconds) = split(":", $time);
      $tot_secs = 0.;
      $tot_secs += 3600 * $hours;
      $tot_secs += 60 * $minutes;
      $tot_secs += $seconds;
    }
  }
  close(LOG);
  if(! defined $nseq_annot) { 
    die "ERROR didn't read number of annotated seqs in $log_file";
  }
  if(! defined $nseq_notannot) { 
    die "ERROR didn't read number of non-annotated seqs in $log_file";
  }
  if(! defined $tot_secs) { 
    die "ERROR didn't read elapsed time in $log_file";
  }

  $sum_nseq += $nseq_annot;
  $sum_nseq += $nseq_notannot;
  $sum_secs += $tot_secs;
}

printf("$category secperseq %.5f\n", $sum_secs / $sum_nseq);
printf("$category tot_secs %.5f\n", $sum_secs);
printf("$category nseq %d\n", $sum_nseq);
