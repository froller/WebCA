package WebCA::Controller::CA;

use utf8;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use WebCA::Const;
use WebCA::Util;

=head1 NAME

WebCA::Controller::CA - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 cerificates

Show issued certificates

=cut

sub certificates :Local :Args(0) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA);
    $c->stash({
        certificates => [$c->user->certificates],
        template     => 'ca/certificates.tt'
    });
}


=head1 AUTHOR

Александр Фролов

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->config(
#   action_roles => [qw(CA)]
);

__PACKAGE__->meta->make_immutable;

1;
