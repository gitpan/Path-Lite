#!perl -T

use strict;
use warnings;

use Test::More (0 ? (tests => 1) : 'no_plan');
use Test::Lazy qw/template try/;
use Scalar::Util qw(refaddr);

use Path::Lite qw/path/;

use vars qw/$c $d/;
sub get { return path(@_)->path }
my $path = path;
$path = new Path::Lite;

my $template = template(\<<_END_);
Path::Lite->new
Path::Lite->new( qw!/! )
Path::Lite->new( qw!a! )
Path::Lite->new( qw!/a! )
Path::Lite->new( qw!a b! )
Path::Lite->new( qw!/a b! )
Path::Lite->new( qw!a b c! )
Path::Lite->new( qw!/a b c! )
Path::Lite->new( qw!a b c! )->set
Path::Lite->new( qw!/a b c! )->set
Path::Lite->new( qw!a b c! )->push( qw!d! )
_END_

# new {{{
$template->test("ref(%?)" => is => "Path::Lite");
# }}}
# path {{{
# }}}
# clone {{{
$template->test([
	[ "%?->clone" => is => "" ],
	[ "%?->clone" => is => "/" ],
	[ "%?->clone" => is => "a" ],
	[ "%?->clone" => is => "/a" ],
	[ "%?->clone" => is => "a/b" ],
	[ "%?->clone" => is => "/a/b" ],
	[ "%?->clone" => is => "a/b/c" ],
	[ "%?->clone" => is => "/a/b/c" ],
	[ "%?->clone" => is => "" ],
	[ "%?->clone" => is => "" ],
	[ "%?->clone" => is => "a/b/c/d" ],
]);
# }}} 
# _canonize {{{
# }}}
# set {{{ 
$template->test("%?->set()" => is => "");
$template->test("%?->set(qw!a/!)" => is => "a");
$template->test("%?->set(qw!/a!)" => is => "/a");
$template->test("%?->set(qw!a b!)" => is => "a/b");
$template->test("%?->set(qw!/a b!)" => is => "/a/b");
$template->test("%?->set(qw!/a b c/!)" => is => "/a/b/c");
# }}}
# is_empty {{{
$template->test([
	[ "%?->is_empty" => is => "1" ],
	[ "%?->is_empty" => is => "" ],
	[ "%?->is_empty" => is => "" ],
	[ "%?->is_empty" => is => "" ],
	[ "%?->is_empty" => is => "" ],
	[ "%?->is_empty" => is => "" ],
	[ "%?->is_empty" => is => "" ],
	[ "%?->is_empty" => is => "" ],
	[ "%?->is_empty" => is => "1" ],
	[ "%?->is_empty" => is => "1" ],
	[ "%?->is_empty" => is => "" ],
]);
# }}}
# is_root {{{
$template->test([
	[ "%?->is_root" => is => "" ],
	[ "%?->is_root" => is => "1" ],
	[ "%?->is_root" => is => "" ],
	[ "%?->is_root" => is => "" ],
	[ "%?->is_root" => is => "" ],
	[ "%?->is_root" => is => "" ],
	[ "%?->is_root" => is => "" ],
	[ "%?->is_root" => is => "" ],
	[ "%?->is_root" => is => "" ],
	[ "%?->is_root" => is => "" ],
	[ "%?->is_root" => is => "" ],
]);
# }}}
# is_tree {{{
$template->test([
	[ "%?->is_tree" => is => "" ],
	[ "%?->is_tree" => is => "1" ],
	[ "%?->is_tree" => is => "" ],
	[ "%?->is_tree" => is => "1" ],
	[ "%?->is_tree" => is => "" ],
	[ "%?->is_tree" => is => "1" ],
	[ "%?->is_tree" => is => "" ],
	[ "%?->is_tree" => is => "1" ],
	[ "%?->is_tree" => is => "" ],
	[ "%?->is_tree" => is => "" ],
	[ "%?->is_tree" => is => "" ],
]);
# }}}
# is_branch {{{
$template->test([
	[ "%?->is_branch" => is => "" ],
	[ "%?->is_branch" => is => "" ],
	[ "%?->is_branch" => is => "1" ],
	[ "%?->is_branch" => is => "" ],
	[ "%?->is_branch" => is => "1" ],
	[ "%?->is_branch" => is => "" ],
	[ "%?->is_branch" => is => "1" ],
	[ "%?->is_branch" => is => "" ],
	[ "%?->is_branch" => is => "" ],
	[ "%?->is_branch" => is => "" ],
	[ "%?->is_branch" => is => "1" ],
]);
# }}}
# to_tree {{{
$template->test([
	[ "%?->to_tree" => is => "/" ],
	[ "%?->to_tree" => is => "/" ],
	[ "%?->to_tree" => is => "/a" ],
	[ "%?->to_tree" => is => "/a" ],
	[ "%?->to_tree" => is => "/a/b" ],
	[ "%?->to_tree" => is => "/a/b" ],
	[ "%?->to_tree" => is => "/a/b/c" ],
	[ "%?->to_tree" => is => "/a/b/c" ],
	[ "%?->to_tree" => is => "/" ],
	[ "%?->to_tree" => is => "/" ],
	[ "%?->to_tree" => is => "/a/b/c/d" ],
]);
# }}}
# to_branch {{{
$template->test([
	[ "%?->to_branch" => is => "" ],
	[ "%?->to_branch" => is => "" ],
	[ "%?->to_branch" => is => "a" ],
	[ "%?->to_branch" => is => "a" ],
	[ "%?->to_branch" => is => "a/b" ],
	[ "%?->to_branch" => is => "a/b" ],
	[ "%?->to_branch" => is => "a/b/c" ],
	[ "%?->to_branch" => is => "a/b/c" ],
	[ "%?->to_branch" => is => "" ],
	[ "%?->to_branch" => is => "" ],
	[ "%?->to_branch" => is => "a/b/c/d" ],
]);
# }}}
# list {{{
$template->test([
	[ "%?->list" => is => [] ],
	[ "%?->list" => is => ["/"] ],
	[ "%?->list" => is => ["a"] ],
	[ "%?->list" => is => ["/a"] ],
	[ "%?->list" => is => ["a","b"] ],
	[ "%?->list" => is => ["/a","b"] ],
	[ "%?->list" => is => ["a", "b", "c"] ],
	[ "%?->list" => is => ["/a", "b", "c"] ],
	[ "%?->list" => is => [] ],
	[ "%?->list" => is => [] ],
	[ "%?->list" => is => ["a", "b", "c", "d"] ],
]);
# }}}
# first {{{
$template->test([
	[ "%?->first" => is => undef ],
	[ "%?->first" => is => ["/"] ],
	[ "%?->first" => is => ["a"] ],
	[ "%?->first" => is => ["/a"] ],
	[ "%?->first" => is => ["a"] ],
	[ "%?->first" => is => ["/a"] ],
	[ "%?->first" => is => ["a"] ],
	[ "%?->first" => is => ["/a"] ],
	[ "%?->first" => is => [] ],
	[ "%?->first" => is => [] ],
	[ "%?->first" => is => ["a"] ],
]);
# }}}
# last {{{
$template->test([
	[ "%?->last" => is => undef ],
	[ "%?->last" => is => ["/"] ],
	[ "%?->last" => is => ["a"] ],
	[ "%?->last" => is => ["/a"] ],
	[ "%?->last" => is => ["b"] ],
	[ "%?->last" => is => ["b"] ],
	[ "%?->last" => is => ["c"] ],
	[ "%?->last" => is => ["c"] ],
	[ "%?->last" => is => [] ],
	[ "%?->last" => is => [] ],
	[ "%?->last" => is => ["d"] ],
]);
# }}}
# get {{{
$template->test([
	[ "%?->get" => is => "" ],
	[ "%?->get" => is => "/" ],
	[ "%?->get" => is => "a" ],
	[ "%?->get" => is => "/a" ],
	[ "%?->get" => is => "a/b" ],
	[ "%?->get" => is => "/a/b" ],
	[ "%?->get" => is => "a/b/c" ],
	[ "%?->get" => is => "/a/b/c" ],
	[ "%?->get" => is => "" ],
	[ "%?->get" => is => "" ],
	[ "%?->get" => is => "a/b/c/d" ],
]);
# }}}
# push {{{
$c = Path::Lite->new(qw|a|);
$d = $c->push(qw|b|);
try("::refaddr(\$::c) == ::refaddr(\$::d)" => is => 1);

$template->test([
	[ "%?->push( qw |e| )" => is => "e" ],
	[ "%?->push( qw |e| )" => is => "/e" ],
	[ "%?->push( qw |e| )" => is => "a/e" ],
	[ "%?->push( qw |e| )" => is => "/a/e" ],
	[ "%?->push( qw |e| )" => is => "a/b/e" ],
	[ "%?->push( qw |e| )" => is => "/a/b/e" ],
	[ "%?->push( qw |e| )" => is => "a/b/c/e" ],
	[ "%?->push( qw |e| )" => is => "/a/b/c/e" ],
	[ "%?->push( qw |e| )" => is => "e" ],
	[ "%?->push( qw |e| )" => is => "e" ],
	[ "%?->push( qw |e| )" => is => "a/b/c/d/e" ],
]);
# }}}
# child {{{
$c = Path::Lite->new(qw|a|);
$d = $c->child(qw|b|);
try("::refaddr(\$::c) == ::refaddr(\$::d)" => is => '');

$template->test([
	[ "%?->child( qw|e| )" => is => "e" ],
	[ "%?->child( qw|e| )" => is => "/e" ],
	[ "%?->child( qw|e| )" => is => "a/e" ],
	[ "%?->child( qw|e| )" => is => "/a/e" ],
	[ "%?->child( qw|e| )" => is => "a/b/e" ],
	[ "%?->child( qw|e| )" => is => "/a/b/e" ],
	[ "%?->child( qw|e| )" => is => "a/b/c/e" ],
	[ "%?->child( qw|e| )" => is => "/a/b/c/e" ],
	[ "%?->child( qw|e| )" => is => "e" ],
	[ "%?->child( qw|e| )" => is => "e" ],
	[ "%?->child( qw|e| )" => is => "a/b/c/d/e" ],
]);
# }}}
# pop {{{
$template->test([
	[ "%?->pop" => is => "" ],
	[ "%?->pop" => is => "" ],
	[ "%?->pop" => is => "a" ],
	[ "%?->pop" => is => "a" ],
	[ "%?->pop" => is => "b" ],
	[ "%?->pop" => is => "b" ],
	[ "%?->pop" => is => "c" ],
	[ "%?->pop" => is => "c" ],
	[ "%?->pop" => is => "" ],
	[ "%?->pop" => is => "" ],
	[ "%?->pop" => is => "d" ],
]);

$template->test([
	[ "%?->pop(2)" => is => "" ],
	[ "%?->pop(2)" => is => "" ],
	[ "%?->pop(2)" => is => "a" ],
	[ "%?->pop(2)" => is => "a" ],
	[ "%?->pop(2)" => is => "a/b" ],
	[ "%?->pop(2)" => is => "a/b" ],
	[ "%?->pop(2)" => is => "b/c" ],
	[ "%?->pop(2)" => is => "b/c" ],
	[ "%?->pop(2)" => is => "" ],
	[ "%?->pop(2)" => is => "" ],
	[ "%?->pop(2)" => is => "c/d" ],
]);
# }}}
# up {{{
$template->test([
	[ "%?->up" => is => "" ],
	[ "%?->up" => is => "/" ],
	[ "%?->up" => is => "" ],
	[ "%?->up" => is => "/" ],
	[ "%?->up" => is => "a" ],
	[ "%?->up" => is => "/a" ],
	[ "%?->up" => is => "a/b" ],
	[ "%?->up" => is => "/a/b" ],
	[ "%?->up" => is => "" ],
	[ "%?->up" => is => "" ],
	[ "%?->up" => is => "a/b/c" ],
]);

$template->test([
	[ "%?->up(2)" => is => "" ],
	[ "%?->up(2)" => is => "/" ],
	[ "%?->up(2)" => is => "" ],
	[ "%?->up(2)" => is => "/" ],
	[ "%?->up(2)" => is => "" ],
	[ "%?->up(2)" => is => "/" ],
	[ "%?->up(2)" => is => "a" ],
	[ "%?->up(2)" => is => "/a" ],
	[ "%?->up(2)" => is => "" ],
	[ "%?->up(2)" => is => "" ],
	[ "%?->up(2)" => is => "a/b" ],
]);
# }}}
# parent {{{
$template->test([
	[ "%?->parent" => is => "" ],
	[ "%?->parent" => is => "/" ],
	[ "%?->parent" => is => "" ],
	[ "%?->parent" => is => "/" ],
	[ "%?->parent" => is => "a" ],
	[ "%?->parent" => is => "/a" ],
	[ "%?->parent" => is => "a/b" ],
	[ "%?->parent" => is => "/a/b" ],
	[ "%?->parent" => is => "" ],
	[ "%?->parent" => is => "" ],
	[ "%?->parent" => is => "a/b/c" ],
]);
# }}}
