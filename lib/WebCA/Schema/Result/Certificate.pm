use utf8;
package WebCA::Schema::Result::Certificate;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WebCA::Schema::Result::Certificate

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

=head1 TABLE: C<certificates>

=cut

__PACKAGE__->table("certificates");

=head1 ACCESSORS

=head2 certificate_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 key_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 certificate_pem

  data_type: 'text'
  is_nullable: 0

=head2 timestamp

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "certificate_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "key_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "certificate_pem",
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

=item * L</certificate_id>

=back

=cut

__PACKAGE__->set_primary_key("certificate_id");

=head1 RELATIONS

=head2 key

Type: belongs_to

Related object: L<WebCA::Schema::Result::KeyPair>

=cut

__PACKAGE__->belongs_to(
  "key",
  "WebCA::Schema::Result::KeyPair",
  { key_id => "key_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OqPz1AlZQexgODOHVRaVlg

__PACKAGE__->load_components('InflateColumn');
__PACKAGE__->inflate_column(
    timestamp => {
       inflate => sub { shift },
       deflate => sub { shift },
    },
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
