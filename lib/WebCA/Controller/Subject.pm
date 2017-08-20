package WebCA::Controller::Subject;

use utf8;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use WebCA::Const;
use WebCA::Util;

=head1 NAME

WebCA::Controller::Subject - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched WebCA::Controller::Subject in Subject.');
}

=head2 keys

Show key pairs

=cut

sub keys :Local {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    $c->stash({
        keys     => [$c->user->key_pairs],
        template => 'subject/keys.tt'
    });
}

=head2 key

Get key

=cut

sub key :Local :Args(2) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    my $key = $c->user->key_pairs->find({key_id => $c->req->args->[0]});
    my $pem;
    if ($key && $c->req->args->[1] eq KEY_PRIVATE) {
        $pem = $key->private_pem;
    } elsif ($key && $c->req->args->[1] eq KEY_PUBLIC) {
        $pem = $key->public_pem;
    } else {
        $c->stash({
            template => 'error.tt'
        });
        $c->response->status(404);
    }
    $c->response->content_type(sprintf('application/x-rsa-%s', lc($c->req->args->[1])));
    $c->response->body($pem);
}

=head2 new_key

Issue new key

=cut

sub new_key :Local :Args(0) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    if ($c->req->param('key_type') && $c->req->param('key_size')) {
        $c->user->gen_key({
            key_name => $c->req->param('key_name'),
            key_type => $c->req->param('key_type'),
            key_size => $c->req->param('key_size'),
        });
        $c->response->redirect($c->uri_for($c->controller->action_for('keys')));
    }
    $c->stash({
        template => 'subject/new_key.tt'
    })
}

=head2 delete_key

Delete key

=cut

sub delete_key :Local :Args(1) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    my $key = $c->user->key_pairs->find({key_id => $c->req->args->[0]});
    if ($c->req->param('ok') || $c->req->param('cancel')) {
        if ($c->req->param('ok')) {
            $key->delete();
        }
        $c->response->redirect($c->uri_for($c->controller->action_for('keys')));
    } else {
        $c->stash({
            key      => $key,
            template => 'subject/delete_key.tt'
        });
    }
}

=head2 requests

Show requests

=cut

sub requests :Local :Args(0) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    $c->stash({
        requests => [$c->user->requests],
        template => 'subject/requests.tt'
    });
}

=head2 request

Get request

=cut

sub request :Local :Args(1) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    $c->stash({
        keys     => [$c->user->key_pairs],
        request  => $c->user->requests->find({
            request_id => $c->request->args->[0]
        }),
        template => 'subject/request.tt'
    });
}

=head2 update_request

Update request

=cut

sub update_request :Local :Args(1) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    my $request = $c->user->requests->find({
        request_id => $c->req->args->[0]
    });
    my $key = $c->user->key_pairs->find({
        key_id => $c->req->param('key_id'),
    });
    my $dn = {
        map {
            $_ => $c->req->param($_)
        } qw(c st l o ou cn email)
    };
    if ($request) {
        $request->delete();
    }
    $c->user->gen_req($key, $dn);
    $c->response->redirect($c->uri_for($c->controller->action_for('requests')));
}

=head2 delete_request

Delete issued request

=cut

sub delete_request :Local :Args(1) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    my $request = $c->user->requests->find({
        request_id => $c->req->args->[0]
    });
    if ($c->req->param('ok') || $c->req->param('cancel')) {
        if ($c->req->param('ok')) {
            $request->delete();
        }
        $c->response->redirect($c->uri_for($c->controller->action_for('requests')));
    } else {
        $c->stash({
            request  => $request,
            template => 'subject/delete_request.tt'
        });
    }
}

=head2 send_request

Send request to CA

=cut

sub send_request :Local :Args(1) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    my $request = $c->user->requests->find({
        request_id => $c->req->args->[0]
    });
    if (!$request) {
        $c->stash({
            template => 'error.tt'
        });
        $c->response->status(404);
    }
    if ($c->req->param('ca')) {
        if ($c->req->param('ok')) {
            $request->send($c->req->param('ca'));
        }
        $c->response->redirect($c->uri_for($c->controller->action_for('requests')));
    } else {
        my $cas = $c->model('DB::User')->search_related_rs('user_roles')->search_related_rs('role', {role_name => [ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA]})->all();
        $c->stash({
            request  => $request,
            cas      => [$cas],
            template => 'subject/send_request.tt'
        });
    }
}

=head2 download_request

Download request as PEM

=cut

sub download_request :Local :Args(1) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    my $request = $c->user->requests->find({
        request_id => $c->req->args->[0]
    });
    my $pem;
    if ($request) {
        $pem = $request->request_pem;
    } else {
        $c->stash({
            template => 'error.tt'
        });
        $c->response->status(404);
    }
    $c->response->content_type(sprintf('application/x-x509-ca-req'));
    $c->response->body($pem);
}

=head2 certificates

Show certificates

=cut

sub certificates :Local :Args(0) {
    my ($self, $c) = @_;
    $c->assert_any_user_role(ROLE_ROOT_CA, ROLE_INTERMEDIATE_CA, ROLE_SUBJECT);
    $c->stash({
        certificates => [$c->user->certificates()],
        template     => 'subject/certificates.tt'
    });
}


=head1 AUTHOR

Александр Фролов

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
