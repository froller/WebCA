package WebCA::Controller::CA::Intermediate;

use utf8;
use Moose;
use namespace::autoclean;

BEGIN {
    extends 'WebCA::Controller::CA';
    extends 'WebCA::Controller::Subject';
}

=head1 NAME

WebCA::Controller::CA::Intermediate - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut




=head1 AUTHOR

Александр Фролов

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->config(
    #action_roles => [qw(Subject)]
);

__PACKAGE__->meta->make_immutable;

1;
