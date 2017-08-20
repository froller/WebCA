package WebCA::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use WebCA::Const;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

WebCA::Controller::Root - Root Controller for WebCA

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    ## Hello World
    #$c->response->body( $c->welcome_message );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head2 auto

=cut

sub auto :Private {
    my ($self, $c) = @_;
    if (
        $c->action eq $c->controller('Root')->action_for('login')
        || $c->action eq $c->controller('Root')->action_for('register')
        || $c->user_exists && $c->user
    ) {
        $c->stash({menu => $self->menu($c)});
    } else {
        $c->response->redirect($c->uri_for($c->controller('Root')->action_for('login')));
        $c->detach;
    }
}

=head2 menu

Menu generator

=cut

sub menu :Private {
    my ($self, $c) = @_;
    my @menu;
    push(@menu, {title => 'Sign In',  link => $c->uri_for($c->controller('Root')->action_for('login'))})
        unless $c->user_exists();

    push(@menu, {title => 'Register', link => $c->uri_for($c->controller('Root')->action_for('register'))})
        unless $c->user_exists();

    push(@menu, {title => 'Home',     link => $c->uri_for($c->controller('Root')->action_for('index'))})
        if $c->user_exists();

    push(@menu, {title => 'Users',    link => $c->uri_for($c->controller('Admin')->action_for('users'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_ADMIN);

    push(@menu, {title => 'My Keys',  link => $c->uri_for($c->controller('CA::Root')->action_for('keys'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_ROOT_CA);
    push(@menu, {title => 'My Keys',  link => $c->uri_for($c->controller('CA::Intermediate')->action_for('keys'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_INTERMEDIATE_CA);
    push(@menu, {title => 'My Keys',  link => $c->uri_for($c->controller('Subject')->action_for('keys'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_SUBJECT);

    #push(@menu, {title => 'My Requests', link => $c->uri_for($c->controller('CA::Root')->action_for('requests'))})
    #    if $c->user_exists() && $c->check_any_user_role(ROLE_ROOT_CA);
    push(@menu, {title => 'My Requests', link => $c->uri_for($c->controller('CA::Intermediate')->action_for('requests'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_INTERMEDIATE_CA);
    push(@menu, {title => 'My Requests', link => $c->uri_for($c->controller('Subject')->action_for('requests'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_SUBJECT);

    push(@menu, {title => 'My Certificates', link => $c->uri_for($c->controller('CA::Root')->action_for('certificates'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_ROOT_CA);
    push(@menu, {title => 'My Certificates', link => $c->uri_for($c->controller('CA::Intermediate')->action_for('certificates'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_INTERMEDIATE_CA);
    push(@menu, {title => 'My Certificates', link => $c->uri_for($c->controller('Subject')->action_for('certificates'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_SUBJECT);

    push(@menu, {title => 'CA',    link => $c->uri_for($c->controller('CA::Root')->action_for('index'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_ROOT_CA);
    push(@menu, {title => 'CA',    link => $c->uri_for($c->controller('CA::Intermediate')->action_for('index'))})
        if $c->user_exists() && $c->check_any_user_role(ROLE_INTERMEDIATE_CA);

    push(@menu, {title => 'Sign Out', link => $c->uri_for($c->controller('Root')->action_for('logout'))})
        if $c->user_exists();
    return \@menu;
}

=head2 login

Authentication handler

=cut

sub login :Local {
    my ($self, $c) = @_;
    if ($c->request->param('username')) {
        if (
            $c->authenticate({
                password => $c->request->param('password'),
                username => $c->request->param('username'),
            })
        ) {
            $c->response->redirect('/');
        } else {
            $c->stash({
                error => {
                    message => 'Login incorrect',
                    description => ''
                }
            });
        }
    }
}

=head2 logout

Deauthentication handler

=cut

sub logout :Local {
    my ($self, $c) = @_;
    $c->logout;
    $c->response->redirect('/');
}

=head1 AUTHOR

Александр Фролов

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
