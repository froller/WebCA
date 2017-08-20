package WebCA::Util;

use utf8;
use strict;
use warnings;

=head2 dn_to_subj($dn)

Convert x509 distinguished name to certificate subject

=cut

sub dn_to_subj {
    my ($dn) = @_;
    my %dn = (map {
        my $key = $_;
        my $value = $dn->{$key};
        $value =~ s|/|\\/|g;
        ($key => $value);
    } keys %$dn);
    return sprintf("/C=%2s/ST=%s/L=%s/O=%s/OU=%s/CN=%s/emailAddress=%s", $dn{c}, $dn{st}, $dn{l}, $dn{o}, $dn{ou}, $dn{cn}, $dn{email});
}

=head2 dn_to_hr($dn)

Convert x509 distinguished name to human readable format

=cut

sub dn_to_hr {
    my ($dn) = @_;
    return sprintf("C=%2s, ST=%s, L=%s, O=%s, OU=%s, CN=%s, emailAddress=%s", $dn->{c}, $dn->{st}, $dn->{l}, $dn->{o}, $dn->{ou}, $dn->{cn}, $dn->{email});
    
}

=head2 subj_to_dn($subj)

Convert certificate subject to x509 distinguished name

=cut

sub subj_to_dn {
    my ($subj) = @_;
    if ($subj =~ m|^/C=(.+?)/ST=(.+?)/L=(.+?)/O=(.+?)/OU=(.+?)/CN=(.+?)/emailAddress=(.+?)$|) {
        my %dn = (
            c     => $1,
            st    => $2,
            l     => $3,
            o     => $4,
            ou    => $5,
            cn    => $6,
            email => $7
        );
        return \%dn;
    } else {
        return undef;
    }
}

1;
