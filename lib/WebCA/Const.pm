package WebCA::Const;

use strict;
use warnings;

use base 'Exporter';
use vars qw(@EXPORT_OK @EXPORT);

@EXPORT_OK = qw(
    ROLE_ADMIN
    ROLE_ROOT_CA
    ROLE_INTERMEDIATE_CA
    ROLE_SUBJECT
    
    KEY_TYPE_RSA
    KEY_TYPE_DSA
    KEY_PRIVATE
    KEY_PUBLIC
    
    DOWNLOAD_FORM_PEM
    
    OPENSSL_BINARY
);
@EXPORT = @EXPORT_OK;

use constant ROLE_ADMIN           => 'admin';
use constant ROLE_ROOT_CA         => 'root';
use constant ROLE_INTERMEDIATE_CA => 'intermediate';
use constant ROLE_SUBJECT         => 'subject';

use constant KEY_TYPE_RSA         => 'RSA';
use constant KEY_TYPE_DSA         => 'DSA';
use constant KEY_PRIVATE          => 'private';
use constant KEY_PUBLIC           => 'public';

use constant DOWNLOAD_FORM_PEM    => 'pem';

use constant OPENSSL_BINARY       => '/usr/bin/openssl';

1;
