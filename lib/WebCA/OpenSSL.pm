package WebCA::OpenSSL;
use MooseX::Singleton;

use IPC::Open3;
use WebCA::Const;
use WebCA::Util;

use constant TRANSLATE_KEY_TYPES => {
    RSA => (KEY_TYPE_RSA),
    DSA => (KEY_TYPE_DSA)
};
use constant TRANSLATE_KEY_COMPLEMENTS => {
    PRIVATE => (KEY_PRIVATE),
    PUBLIC  => (KEY_PUBLIC)
};
use constant TRANSLATE_OPENSSL_PARAMS => {
    (KEY_TYPE_RSA) => 'rsa',
    (KEY_TYPE_DSA) => 'dsa'
};

=head1 NAME

WebCA::OpenSSL - Model

=head1 DESCRIPTION

OpenSSL data model

=cut

=head2 call

Performs call to openssl as an external process

=cut

sub call {
    my ($self, $in, @args) = @_;
    my $out = '';
    my $err = '';
    my $exitcode = undef;
    local (*REAL_STDIN, *REAL_STDOUT, *REAL_STDERR);
    open(*REAL_STDIN,  "<&=0") or die $!;
    open(*REAL_STDOUT, ">>&=1") or die $!;
    open(*REAL_STDERR, ">>/dev/null") or die $!;
    {
        local *STDIN  = *REAL_STDIN;
        local *STDOUT = *REAL_STDOUT;
        local *STDERR = *REAL_STDERR;
        my ($chldin, $chldout, $chlderr);
        my $pid = open3($chldin, $chldout, $chlderr, '/usr/bin/openssl', @args) or die $!;
        print($chldin $in) if defined($in);
        close($chldin);
        if (waitpid($pid, 0) > 0) {
            $exitcode = $? >> 8;
        }
        local $/ = '';
        $out = <$chldout>;
    };
    if (wantarray()) {
        return ($out, $exitcode);
    }
    return $out;
}

=head2 gen_key($key_type, $key_size)

Generates key of type $key_type and size $key_size

=cut

sub gen_key {
    my ($self, $key_type, $key_size) = @_;
    if ($key_type eq KEY_TYPE_RSA) {
        my $rsa = $self->genrsa($key_size);
        return ($rsa, $self->rsapub($rsa));
    } elsif ($key_type eq KEY_TYPE_DSA) {
        my $params = $self->dsaparam($key_size);
        my $dsa = $self->gendsa($params);
        return ($dsa, $self->dsapub($dsa));
    }
    return undef;
}

=head2 genrsa($size)

Generates RSA key of size $size

=cut

sub genrsa {
    my ($self, $size) = @_;
    return $self->call(undef, 'genrsa', $size);
}

=head2 rsapub($rsa)

Returns RSA public key for $rsa key

=cut

sub rsapub {
    my ($self, $rsa) = @_;
    return $self->call($rsa, 'rsa', '-pubout');
}

=head2 dsaparam($size)

Generates DSA parameters of size $size

=cut

sub dsaparam {
    my ($self, $size) = @_;
    return $self->call(undef, 'dsaparam', $size);
}

=head2 gendsa($dsaparam)

Generates DSA key with $dsaparam parameters

=cut

sub gendsa {
    my ($self, $dsaparam) = @_;
    return $self->call($dsaparam, 'gendsa', '/dev/stdin');
}

=head2 dsapub($dsa)

Returns DSA public key for $dsa key

=cut

sub dsapub {
    my ($self, $dsa) = @_;
    return $self->call($dsa, 'dsa', '-pubout');
}

=head2 test_key($pem)

Tests PEM data to find out key type and size

=cut

sub test_key {
    my ($self, $data, $passphrase) = @_;
    my %result;
    $self->_parse_attributes($data, \%result);
    $self->_determine_key_spec($data, \%result);
    if (
        exists $result{attributes}{'Proc-Type'}
        && $result{attributes}{'Proc-Type'} eq '4,ENCRYPTED'
    ) {
        if (defined($passphrase)) {
            $result{passphrase} = $passphrase;
        } else {
            return %result;
        }
    }
    $self->_determine_key_size($data, \%result);
    delete($result{passphrase});
    return %result;
}

sub _determine_key_spec {
    my ($self, $data, $resultref) = @_;
    if (
        $data =~ /^-{5}BEGIN ((RSA|DSA) (PRIVATE)|(PUBLIC)) KEY-{5}\n(?:((?:(?:\w|-)+:\s.+\n)+)\n)?[A-Za-z0-9\/+\n]+=*\n-{5}END ((?:RSA|DSA) PRIVATE|PUBLIC) KEY-{5}\n$/
        && $1 eq $6
    ) {
        $resultref->{type} = TRANSLATE_KEY_TYPES->{$2} if defined $2;
        $resultref->{complement} = TRANSLATE_KEY_COMPLEMENTS->{$3 || $4};
        return %$resultref;
    }
    return undef;   # if it not seems to be PEM
}

sub _determine_key_size {
    my ($self, $data, $resultref) = @_;
    return $self->_extract_pem_data($data, $resultref);
}

sub _extract_pem_data {
    my ($self, $data, $resultref) = @_;
    my $out;
    my $err;
    my $openssl = new WebCA::OpenSSL;
    if (
        $resultref->{complement} eq KEY_PRIVATE
        && (
            $resultref->{type} eq KEY_TYPE_RSA
            || $resultref->{type} eq KEY_TYPE_DSA
        )
    ) {
        my @args = qw(-text -noout);
        if (
            exists($resultref->{passphrase})
            && defined($resultref->{passphrase})
        ) {
            push(@args, '-passin');
            push(@args, sprintf('pass:%s', $resultref->{passphrase}));
        }
        ($out, $err) = $openssl->call($data, TRANSLATE_OPENSSL_PARAMS->{$resultref->{type}}, @args);
        return $self->_parse_extracted_pem_data($out, $resultref);
    } elsif ($resultref->{complement} eq KEY_PUBLIC) {
        return %$resultref; # don't try to look inside public key: it's useless
    }
    return undef; # if key complement isn't defined
}

sub _parse_extracted_pem_data {
    my ($self, $pemtext, $resultref) = @_;
    if ($pemtext =~ /(?:Private|Public)-Key:\s+\((\d+) bit\)\n/) {
        $resultref->{size} = $1;
        return %$resultref;
    }
    return undef;
}

sub _parse_attributes {
    my ($self, $data, $resultref) = @_;
    $resultref->{attributes} = {};
    while ($data =~ s/^(.+): (.+)\n$//m) {
        my $name = $1;
        my $value = $2;
        $resultref->{attributes}{$name} = $value;
    }
    return %$resultref;
}

=head2 gen_req

Generate x509 request

=cut

sub gen_req {
    my ($self, $key, $dn) = @_;
    my $subj = WebCA::Util::dn_to_subj($dn);
    return $self->call($key, 'req', '-new', '-key', '/dev/stdin', '-subj', $subj, '-text');
}

=head1 AUTHOR

Александр Фролов

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
