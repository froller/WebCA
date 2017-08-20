use utf8;
package WebCA::Schema::Result::KeyPair;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WebCA::Schema::Result::KeyPair

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

=head1 TABLE: C<key_pairs>

=cut

__PACKAGE__->table("key_pairs");

=head1 ACCESSORS

=head2 key_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 key_type

  data_type: 'enum'
  extra: {list => ["RSA","DSA"]}
  is_nullable: 0

=head2 key_size

  data_type: 'integer'
  default_value: 1024
  is_nullable: 0

=head2 key_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 private_pem

  data_type: 'text'
  is_nullable: 0

=head2 public_pem

  data_type: 'text'
  is_nullable: 0

=head2 timestamp

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "key_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "key_type",
  {
    data_type => "enum",
    extra => { list => ["RSA", "DSA"] },
    is_nullable => 0,
  },
  "key_size",
  { data_type => "integer", default_value => 1024, is_nullable => 0 },
  "key_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "private_pem",
  { data_type => "text", is_nullable => 0 },
  "public_pem",
  { data_type => "text", is_nullable => 0 },
  "timestamp",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</key_id>

=back

=cut

__PACKAGE__->set_primary_key("key_id");

=head1 RELATIONS

=head2 certificates

Type: has_many

Related object: L<WebCA::Schema::Result::Certificate>

=cut

__PACKAGE__->has_many(
  "certificates",
  "WebCA::Schema::Result::Certificate",
  { "foreign.key_id" => "self.key_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 requests

Type: has_many

Related object: L<WebCA::Schema::Result::Request>

=cut

__PACKAGE__->has_many(
  "requests",
  "WebCA::Schema::Result::Request",
  { "foreign.key_id" => "self.key_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<WebCA::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "WebCA::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-03-28 15:41:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lzhoODwsvijC3Egs/Nt96A

__PACKAGE__->load_components('InflateColumn');
__PACKAGE__->inflate_column(
    timestamp => {
       inflate => sub { shift },
       deflate => sub { shift },
    },
);

sub used {
    my ($self, $request_id) = @_;
    if ($request_id) {
        return $self->requests->count({
            -NOT => {
                request_id => $request_id,
            }
        });
    } else {
        return $self->requests->count();
    }
}
    
1;
