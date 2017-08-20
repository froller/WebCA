use strict;
use warnings;
use Test::More (tests => 4);

use_ok('WebCA::Util');

is(
    WebCA::Util::dn_to_subj({
        c     => 'RU',
        st    => 'State',
        l     => 'City',
        o     => 'Org',
        ou    => 'Unit',
        cn    => 'Name',
        email => 'mail@domain'
    }),
    '/C=RU/ST=State/L=City/O=Org/OU=Unit/CN=Name/emailAddress=mail@domain'
);

is(
    WebCA::Util::dn_to_hr({
        c     => 'RU',
        st    => 'State',
        l     => 'City',
        o     => 'Org',
        ou    => 'Unit',
        cn    => 'Name',
        email => 'mail@domain'
    }),
    'C=RU, ST=State, L=City, O=Org, OU=Unit, CN=Name, emailAddress=mail@domain'
);

is_deeply(
    WebCA::Util::subj_to_dn('/C=RU/ST=State/L=City/O=Org/OU=Unit/CN=Name/emailAddress=mail@domain'),
    {
        c     => 'RU',
        st    => 'State',
        l     => 'City',
        o     => 'Org',
        ou    => 'Unit',
        cn    => 'Name',
        email => 'mail@domain'
    }
);

done_testing();
