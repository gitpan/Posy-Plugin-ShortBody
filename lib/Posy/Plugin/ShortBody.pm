package Posy::Plugin::ShortBody;
use strict;

=head1 NAME

Posy::Plugin::ShortBody - Posy plugin to give the start of an entry body.

=head1 VERSION

This describes version B<0.52> of Posy::Plugin::ShortBody.

=cut

our $VERSION = '0.52';

=head1 SYNOPSIS

    @plugins = qw(Posy::Core
	...
	Posy::Plugin::ShortBody));
    @entry_actions = qw(header
	    ...
	    parse_entry
	    short_body
	    render_entry
	);

=head1 DESCRIPTION

Purpose: Populates the flavour template variable $entry_short_body with the
first sentence of the entry body (defined as everything before the first .,
!, or ?) and strips out HTML tags along the way.  Perfect for providing
shortened, plaintext versions of stories for an RSS feed or summary index.

This creates a 'short_body' entry action, which should be placed
after 'parse_entry' in the entry_action list, and before 'render_entry'.

=head2 Configuration

This expects configuration settings in the $self->{config} hash,
which, in the default Posy setup, can be defined in the main "config"
file in the data directory.

=over

=item B<short_body_after_first_header>

If true, removes everything up to the first header it encounters in the body,
and uses the first sentence after that. (1 is true, 0 is false)
(default: true)

=item B<short_body_replace_body>

If the short_body_replace_body option is true, then this I<replaces>
$entry_body with the short body contents.  This is useful when
one wishes to speed processing when one knows that only the short
body is going to be used (such as in chrono/category index pages).
This needs to be done with care, naturally.
(default: false)

=back

=cut

=head1 OBJECT METHODS

Documentation for developers and those wishing to write plugins.

=head2 init

Do some initialization; make sure that default config values are set.

=cut
sub init {
    my $self = shift;
    $self->SUPER::init();

    # set defaults
    $self->{config}->{short_body_after_first_header} = 1
	if (!defined $self->{config}->{short_body_after_first_header});
    $self->{config}->{short_body_replace_body} = 0
	if (!defined $self->{config}->{short_body_replace_body});
} # init

=head1 Entry Action Methods

Methods implementing per-entry actions.

=head2 short_body

$self->short_body($flow_state, $current_entry, $entry_state)

Parses $current_entry->{body} into $current_entry->{short_body}
If $self->{config}->{short_body_replace_body} is true, then also
sets $current_entry->{body}.

=cut
sub short_body {
    my $self = shift;
    my $flow_state = shift;
    my $current_entry = shift;
    my $entry_state = shift;

    my $body = $current_entry->{body};
    if ($self->{config}->{short_body_after_first_header})
    {
	my ($pre_header, $header, $rest) = split(/<\/?h\d[^>]*>/, $body, 3);
	$body = $rest;
    }
    # strip the HTML tags
    $body =~ s/<[^>]+>//gs;
    # strip out leading spaces
    $body =~ s/^\s*//gs;
    # get the first sentence
    $body =~ s/([\.\!\?]).+$/$1/s;
    $current_entry->{short_body} = $body;
    $current_entry->{body} = $body
	if ($self->{config}->{short_body_replace_body});
    1;
} # short_body

=head1 INSTALLATION

Installation needs will vary depending on the particular setup a person
has.

=head2 Administrator, Automatic

If you are the administrator of the system, then the dead simple method of
installing the modules is to use the CPAN or CPANPLUS system.

    cpanp -i Posy::Plugin::ShortBody

This will install this plugin in the usual places where modules get
installed when one is using CPAN(PLUS).

=head2 Administrator, By Hand

If you are the administrator of the system, but don't wish to use the
CPAN(PLUS) method, then this is for you.  Take the *.tar.gz file
and untar it in a suitable directory.

To install this module, run the following commands:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

Or, if you're on a platform (like DOS or Windows) that doesn't like the
"./" notation, you can do this:

   perl Build.PL
   perl Build
   perl Build test
   perl Build install

=head2 User With Shell Access

If you are a user on a system, and don't have root/administrator access,
you need to install Posy somewhere other than the default place (since you
don't have access to it).  However, if you have shell access to the system,
then you can install it in your home directory.

Say your home directory is "/home/fred", and you want to install the
modules into a subdirectory called "perl".

Download the *.tar.gz file and untar it in a suitable directory.

    perl Build.PL --install_base /home/fred/perl
    ./Build
    ./Build test
    ./Build install

This will install the files underneath /home/fred/perl.

You will then need to make sure that you alter the PERL5LIB variable to
find the modules, and the PATH variable to find the scripts (posy_one,
posy_static).

Therefore you will need to change:
your path, to include /home/fred/perl/script (where the script will be)

	PATH=/home/fred/perl/script:${PATH}

the PERL5LIB variable to add /home/fred/perl/lib

	PERL5LIB=/home/fred/perl/lib:${PERL5LIB}

=head1 REQUIRES

    Posy
    Posy::Core

    Test::More

=head1 SEE ALSO

perl(1).
Posy

=head1 BUGS

Please report any bugs or feature requests to the author.

=head1 AUTHOR

    Kathryn Andersen (RUBYKAT)
    perlkat AT katspace dot com
    http://www.katspace.com

=head1 COPYRIGHT AND LICENCE

Copyright (c) 2004-2005 by Kathryn Andersen

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Posy::Plugin::ShortBody
__END__
