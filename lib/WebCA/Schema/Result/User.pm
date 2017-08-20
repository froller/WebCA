use utf8;
package WebCA::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WebCA::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 password

  data_type: 'char'
  is_nullable: 0
  size: 41

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "password",
  { data_type => "char", is_nullable => 0, size => 41 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<users_uni_1>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("users_uni_1", ["username"]);

=head1 RELATIONS

=head2 certificates

Type: has_many

Related object: L<WebCA::Schema::Result::Certificate>

=cut

__PACKAGE__->has_many(
  "certificates",
  "WebCA::Schema::Result::Certificate",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 key_pairs

Type: has_many

Related object: L<WebCA::Schema::Result::KeyPair>

=cut

__PACKAGE__->has_many(
  "key_pairs",
  "WebCA::Schema::Result::KeyPair",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 requests

Type: has_many

Related object: L<WebCA::Schema::Result::Request>

=cut

__PACKAGE__->has_many(
  "requests",
  "WebCA::Schema::Result::Request",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<WebCA::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "WebCA::Schema::Result::UserRole",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "user_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-03-28 15:41:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X+pSbdoS8P/zJOql6WC6AQ

use WebCA::OpenSSL;

=head2 check_password()

Needed for Catalyst::Pluging::Authentication::Store::DBIC

=cut

sub check_password {
    my ($self, $password) = @_;
    my $user = $self->result_source()->resultset()->find(
        {
            user_id => $self->user_id,
        },
        {
            select => \['me.password = password(?) AS password_ok', [dummy => $password]],
            as => ['password_ok']
        }
    );
    return $user->get_column('password_ok');
}

=head2 has_role($roleName)

Checks if user has specific role

=cut

sub has_role {
    my ($self, $roleName) = @_;
    return grep {$_->role_name eq $roleName} $self->roles();
}

=head2 gen_key($key)

Generates key

=cut

sub gen_key {
    my ($self, $key) = @_;
    my $openssl = WebCA::OpenSSL->instance;
    my ($priv, $pub) = $openssl->gen_key($key->{key_type}, $key->{key_size});
    $self->add_to_key_pairs({
        key_name => $key->{key_name},
        key_type => $key->{key_type},
        key_size => $key->{key_size},
        private_pem => $priv,
        public_pem  => $pub,
    });
}

=head2 upload_key($key)

Upload key

=cut

sub upload_key {
    my ($self, $key) = @_;
    my $openssl = WebCA::OpenSSL->instance;
    my ($priv, $pub, $type, $size) = $openssl->test_key($key->{pem});
    $self->add_to_key_pairs({
        key_name => $key->{key_name},
        key_type => $key->{key_type},
        key_size => $key->{key_size},
        private_pem => $priv,
        public_pem  => $priv,
    })
}

=head2 gen_req($key, $dn)

Generate certificate request

=cut

sub gen_req {
    my ($self, $key, $dn) = @_;
    my $openssl = WebCA::OpenSSL->instance;
    my $x509 = $openssl->gen_req($key->private_pem, $dn);
    $self->add_to_requests({
        key_id      => $key->key_id,
        request_pem => $x509,
        %$dn,
    });
}

1;
