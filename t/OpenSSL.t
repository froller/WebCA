use strict;
use warnings;
use Test::More (tests => 14);

use_ok('WebCA::OpenSSL');

my ($openssl, $result);

ok($openssl = WebCA::OpenSSL->new(), 'new');
like($openssl->call(undef, qw(version -v)), qr/^OpenSSL\s/, 'call(undef, @args)');
is($openssl->call('test', qw(enc -des -k test -a -nosalt)), "usq4QY18tzU=\n", 'call($in, @args)');
is(($openssl->call(undef, qw(version -throwexception)))[1], 1, '($out, $exitcode) = call(undef, @args)');
like($openssl->genrsa(128), qr/^-{5}BEGIN RSA PRIVATE KEY-{5}\n[A-Za-z0-9\/+\n]+=*\n-{5}END RSA PRIVATE KEY-{5}\n$/, 'genrsa');
like($openssl->rsapub(<<RSA), qr/^-{5}BEGIN PUBLIC KEY-{5}\n[A-Za-z0-9\/+\n]+=*\n-{5}END PUBLIC KEY-{5}\n$/, 'rsapub');
-----BEGIN RSA PRIVATE KEY-----
MGICAQACEQDQrr+Zbc1i1lImNeXIjkCXAgMBAAECEEmO33C4uKX2nNJTvwiPY6EC
CQDzaNesuNIlxwIJANt6D+pERM6xAgkA3eev7+wS0ZMCCD2vzRFXJs/BAghKAt/q
CPYVkA==
-----END RSA PRIVATE KEY-----
RSA
like($openssl->dsaparam(128), qr/^-{5}BEGIN DSA PARAMETERS-{5}\n[A-Za-z0-9\/+\n]+=*\n-{5}END DSA PARAMETERS-{5}\n$/, 'dsaparam');
like($openssl->gendsa(<<PARAMS), qr/^-{5}BEGIN DSA PRIVATE KEY-{5}\n[A-Za-z0-9\/+\n]+=*\n-{5}END DSA PRIVATE KEY-{5}\n$/, 'gendsa');
-----BEGIN DSA PARAMETERS-----
MIGdAkEA+NmIhGA8HZYUpg6p0mfRCN5i58ZKwkprFGa1G5Q8Z9SJ1qsNeDNU1W5O
HLz5spSb65wL0hAXllPpPef8QiOLLQIVAPNgnR1+1GaiC1dCDEKXznty7K2TAkEA
3CV57L54VzNjEAfMydfA9LDU4R7LGEqiyjBzU8S+r41w7/LEUChBhTHyhUDi8wYr
0OD/Sn2tq2VQkdZ2wjVDFw==
-----END DSA PARAMETERS-----
PARAMS
like($openssl->dsapub(<<DSA), qr/^-{5}BEGIN PUBLIC KEY-{5}\n[A-Za-z0-9\/+\n]+=*\n-{5}END PUBLIC KEY-{5}\n$/, 'dsapub');
-----BEGIN DSA PRIVATE KEY-----
MIH5AgEAAkEA+NmIhGA8HZYUpg6p0mfRCN5i58ZKwkprFGa1G5Q8Z9SJ1qsNeDNU
1W5OHLz5spSb65wL0hAXllPpPef8QiOLLQIVAPNgnR1+1GaiC1dCDEKXznty7K2T
AkEA3CV57L54VzNjEAfMydfA9LDU4R7LGEqiyjBzU8S+r41w7/LEUChBhTHyhUDi
8wYr0OD/Sn2tq2VQkdZ2wjVDFwJBAIZ/4TsgjnNul2mV5aJMbigbZOpEhq6q95Ya
fUuuEWYKuZiDHccGzt+oc8Vz74qrV/zuid/AkXwNfeelHZ6LeM4CFCzy95Eb1dmZ
xjRhFBRPrx6kWHu5
-----END DSA PRIVATE KEY-----
DSA
is_deeply({$openssl->test_key(<<RSA)}, {type => 'RSA', complement => 'private', size => 128, attributes => {}}, 'test_key() RSA');
-----BEGIN RSA PRIVATE KEY-----
MGICAQACEQDQrr+Zbc1i1lImNeXIjkCXAgMBAAECEEmO33C4uKX2nNJTvwiPY6EC
CQDzaNesuNIlxwIJANt6D+pERM6xAgkA3eev7+wS0ZMCCD2vzRFXJs/BAghKAt/q
CPYVkA==
-----END RSA PRIVATE KEY-----
RSA
is_deeply({$openssl->test_key(<<DSA)}, {type => 'DSA', complement => 'private', size => 512, attributes => {}}, 'test_key() DSA');
-----BEGIN DSA PRIVATE KEY-----
MIH5AgEAAkEA+NmIhGA8HZYUpg6p0mfRCN5i58ZKwkprFGa1G5Q8Z9SJ1qsNeDNU
1W5OHLz5spSb65wL0hAXllPpPef8QiOLLQIVAPNgnR1+1GaiC1dCDEKXznty7K2T
AkEA3CV57L54VzNjEAfMydfA9LDU4R7LGEqiyjBzU8S+r41w7/LEUChBhTHyhUDi
8wYr0OD/Sn2tq2VQkdZ2wjVDFwJBAIZ/4TsgjnNul2mV5aJMbigbZOpEhq6q95Ya
fUuuEWYKuZiDHccGzt+oc8Vz74qrV/zuid/AkXwNfeelHZ6LeM4CFCzy95Eb1dmZ
xjRhFBRPrx6kWHu5
-----END DSA PRIVATE KEY-----
DSA
is_deeply({$openssl->test_key(<<RSA, 'test')}, {type => 'RSA', complement => 'private', size => 128, attributes => {'Proc-Type' => '4,ENCRYPTED', 'DEK-Info' => 'DES-CBC,8502745D9120AABB'}}, 'test_key() RSA-DES');
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-CBC,8502745D9120AABB

9gYwkK3XYOLq7tr/Jsoo+ntyAZXezKm7865grXZQnxjHvSt7lTRelFYg7cHW95+h
MMPJljxj5ETLJsUAfHR6zHSr8qdUdlq9dns1cC00VD+QH4WhXcRIbW8uXXfSmCNU
oCkWSoUOsO0=
-----END RSA PRIVATE KEY-----
RSA
is_deeply({$openssl->test_key(<<RSA)}, {type => 'RSA', complement => 'private', attributes => {'Proc-Type' => '4,ENCRYPTED', 'DEK-Info' => 'DES-CBC,8502745D9120AABB'}}, 'test_key() RSA-DES');
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-CBC,8502745D9120AABB

9gYwkK3XYOLq7tr/Jsoo+ntyAZXezKm7865grXZQnxjHvSt7lTRelFYg7cHW95+h
MMPJljxj5ETLJsUAfHR6zHSr8qdUdlq9dns1cC00VD+QH4WhXcRIbW8uXXfSmCNU
oCkWSoUOsO0=
-----END RSA PRIVATE KEY-----
RSA
