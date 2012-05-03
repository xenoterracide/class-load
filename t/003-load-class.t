#!/usr/bin/env perl
use strict;
use warnings;
use Test::More 0.88;
use lib 't/lib';
use Test::Class::Load ':all';
use Test::Fatal;

is(load_class('Class::Load::OK'), 'Class::Load::OK', 'loaded class OK');
is($Class::Load::ERROR, undef, 'ERROR undef');

like( exception {
    load_class('Class::Load::Nonexistent')
}, qr{^Can't locate Class/Load/Nonexistent.pm in \@INC},
   'Nonexistant exception'
);

like(
   $Class::Load::ERROR,
   qr{^Can't locate Class/Load/Nonexistent.pm in \@INC},
   'Nonexistant ERROR message',
);

is(load_class('Class::Load::OK'), 'Class::Load::OK', "loaded class OK");
is($Class::Load::ERROR, undef);

like( exception {
    load_class('Class::Load::SyntaxError')
}, qr{^Missing right curly or square bracket at });
like($Class::Load::ERROR, qr{^Missing right curly or square bracket at });

ok(is_class_loaded('Class::Load::OK'));
ok(!is_class_loaded('Class::Load::Nonexistent'));
ok(!is_class_loaded('Class::Load::SyntaxError'));

do {
    package Class::Load::Inlined;
    sub inlined { 1 }
};

is(load_class('Class::Load::Inlined'),
    'Class::Load::Inlined',
    'loaded class Inlined');

is($Class::Load::ERROR, undef);
ok(is_class_loaded('Class::Load::Inlined'));

like( exception {
    load_class('Class::Load::VersionCheck', { -version => 43 })
}, qr/^Class::Load::VersionCheck version 43 required/);

is(load_class('Class::Load::VersionCheck', { -version => 41 }),
   'Class::Load::VersionCheck',
   "loaded class with version check");

is(load_class('Class::Load::VersionCheck2', { -version => 41 }),
   'Class::Load::VersionCheck2',
   "loaded class with version check");

like( exception {
    load_class('Class::Load::VersionCheck2', { -version => 43 })
}, qr/^Class::Load::VersionCheck2 version 43 required/);

like( exception {
    load_class('__PACKAGE__')
}, qr/__PACKAGE__\.pm.*\@INC/, 'errors sanely on __PACKAGE__.pm' );

done_testing;
