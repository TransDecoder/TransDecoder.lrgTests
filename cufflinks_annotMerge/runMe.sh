#!/bin/bash -ve

export PERL_HASH_SEED=0

merged.gtf.gz  merged.transcripts.fasta.gz
TRANSCRIPTS_GTF="cuffmerged.gtf"
TRANSCRIPTS_FASTA="cuffmerged.transcripts.fasta"

if [ ! -e $TRANSCRIPTS_GTF ]; then
    gunzip -c ${TRANSCRIPTS_GTF}.gz > $TRANSCRIPTS_GTF
fi

if [ ! -e $TRANSCRIPTS_FASTA ]; then
    gunzip -c ${TRANSCRIPTS_FASTA}.gz > $TRANSCRIPTS_FASTA
fi

ln -s $TRANSCRIPTS_GTF transcripts.gtf
ln -s $TRANSCRIPTS_FASTA transcripts.fasta



## generate alignment gff3 formatted output
../../util/cufflinks_gtf_to_alignment_gff3.pl transcripts.gtf > transcripts.gff3

## Extract the long ORFs
../../TransDecoder.LongOrfs -t transcripts.fasta


## Predict likely ORFs
if [ $1 ]; then

    ## run blast

    ## run pfam


    ## use pfam and blast results:
    ../../TransDecoder.Predict  -t transcripts.fasta --retain_pfam_hits pfam.domtblout --retain_blastp_hits blastp.results.outfmt6 -v
else
    # just coding metrics
    ../../TransDecoder.Predict -t transcripts.fasta 
fi


## convert to genome coordinates
../../util/cdna_alignment_orf_to_genome_orf.pl transcripts.fasta.transdecoder.gff3 transcripts.gff3 transcripts.fasta > transcripts.fasta.transdecoder.genome.gff3



echo
echo
echo Done! 
echo
echo 

exit 0
