package WebCA::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use WebCA::Const;

=head1 NAME

WebCA::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut



=head2 users

User list

=cut

sub users :Local :Args(0) {
    my ($self, $c) = @_;
    $c->assert_user_roles(ROLE_ADMIN);
    $c->stash({
        users => [$c->model('DB::User')->all()]
    });
}

=head2 user

User info

=cut

sub user :Local :Args(1) {
    my ($self, $c) = @_;
    $c->assert_user_roles(ROLE_ADMIN);
    $c->stash({
        user => $c->model('DB::User')->find({user_id => $c->req->args->[0]})
    });
}

=head2 update_user

Create user or updates user info

=cut

sub update_user :Local :Args(1) {
    my ($self, $c) = @_;
    $c->assert_user_roles(ROLE_ADMIN);
    my $user = $c->model('DB::User')->find({
        user_id => $c->req->args->[0]
    });
    my $user_data = {
        username => $c->req->param('username'),
        password => \['password(?)', [dummy => ($c->req->param('password'))[0]]],
        email    => $c->req->param('email')
    };
    if ($user) {
        $user->update($user_data);
        $user->delete_related('user_roles', {});
    } else {
        $user = $c->model('DB::User')->create($user_data);
    }
    foreach my $role (($c->req->param('roles'))) {
        $user->add_to_roles({role_name => $role});
    }
    $c->response->redirect($c->uri_for($c->controller('Admin')->action_for('users')));
}

=head2 delete_user

Deletes user

=cut

sub delete_user :Local :Args(1) {
    my ($self, $c) = @_;
    $c->assert_user_roles(ROLE_ADMIN);
    my $user = $c->model('DB::User')->find({user_id => $c->req->args->[0]});
    if ($c->req->param('ok') || $c->req->param('cancel')) {
        if ($c->req->param('ok')) {
            $user->delete();
        }
        $c->response->redirect($c->uri_for($c->controller->action_for('users')));
    } else {
        $c->stash({
            user => $user
        });
    }
}

=head1 AUTHOR

Александр Фролов

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
