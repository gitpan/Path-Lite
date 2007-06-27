#!perl -T

use strict;
use warnings;

use Test::More (0 ? (tests => 1) : 'no_plan');
use JSON;
use lib (qw/lib/);

use Path::Lite;

sub path { return Path::Lite->new(@_) }
sub get { return path(@_)->get }

my $path = path;
$path = new Path::Lite;

my @set = map { [ $_ ] } grep { length $_ } split m/\n/, <<_END_;
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

Set_test(\@set, "%->set()" => is => "");
Set_test(\@set, "%->set(qw!a/!)" => is => "a");
Set_test(\@set, "%->set(qw!/a!)" => is => "/a");
Set_test(\@set, "%->set(qw!a b!)" => is => "a/b");
Set_test(\@set, "%->set(qw!/a b!)" => is => "/a/b");
Set_test(\@set, "%->set(qw!/a b c/!)" => is => "/a/b/c");

Set_test(\@set, [
	[ "%->is_empty" => is => "1" ],
	[ "%->is_empty" => is => "" ],
	[ "%->is_empty" => is => "" ],
	[ "%->is_empty" => is => "" ],
	[ "%->is_empty" => is => "" ],
	[ "%->is_empty" => is => "" ],
	[ "%->is_empty" => is => "" ],
	[ "%->is_empty" => is => "" ],
	[ "%->is_empty" => is => "1" ],
	[ "%->is_empty" => is => "1" ],
	[ "%->is_empty" => is => "" ],
]);

Set_test(\@set, [
	[ "%->is_root" => is => "" ],
	[ "%->is_root" => is => "1" ],
	[ "%->is_root" => is => "" ],
	[ "%->is_root" => is => "" ],
	[ "%->is_root" => is => "" ],
	[ "%->is_root" => is => "" ],
	[ "%->is_root" => is => "" ],
	[ "%->is_root" => is => "" ],
	[ "%->is_root" => is => "" ],
	[ "%->is_root" => is => "" ],
	[ "%->is_root" => is => "" ],
]);

Set_test(\@set, [
	[ "%->is_tree" => is => "" ],
	[ "%->is_tree" => is => "1" ],
	[ "%->is_tree" => is => "" ],
	[ "%->is_tree" => is => "1" ],
	[ "%->is_tree" => is => "" ],
	[ "%->is_tree" => is => "1" ],
	[ "%->is_tree" => is => "" ],
	[ "%->is_tree" => is => "1" ],
	[ "%->is_tree" => is => "" ],
	[ "%->is_tree" => is => "" ],
	[ "%->is_tree" => is => "" ],
]);

Set_test(\@set, [
	[ "%->is_branch" => is => "" ],
	[ "%->is_branch" => is => "" ],
	[ "%->is_branch" => is => "1" ],
	[ "%->is_branch" => is => "" ],
	[ "%->is_branch" => is => "1" ],
	[ "%->is_branch" => is => "" ],
	[ "%->is_branch" => is => "1" ],
	[ "%->is_branch" => is => "" ],
	[ "%->is_branch" => is => "" ],
	[ "%->is_branch" => is => "" ],
	[ "%->is_branch" => is => "1" ],
]);

Set_test(\@set, [
	[ "%->list" => is => [] ],
	[ "%->list" => is => ["/"] ],
	[ "%->list" => is => ["a"] ],
	[ "%->list" => is => ["/a"] ],
	[ "%->list" => is => ["a","b"] ],
	[ "%->list" => is => ["/a","b"] ],
	[ "%->list" => is => ["a", "b", "c"] ],
	[ "%->list" => is => ["/a", "b", "c"] ],
	[ "%->list" => is => [] ],
	[ "%->list" => is => [] ],
	[ "%->list" => is => ["a", "b", "c", "d"] ],
]);

Set_test(\@set, [
	[ "%->first" => is => undef ],
	[ "%->first" => is => ["/"] ],
	[ "%->first" => is => ["a"] ],
	[ "%->first" => is => ["/a"] ],
	[ "%->first" => is => ["a"] ],
	[ "%->first" => is => ["/a"] ],
	[ "%->first" => is => ["a"] ],
	[ "%->first" => is => ["/a"] ],
	[ "%->first" => is => [] ],
	[ "%->first" => is => [] ],
	[ "%->first" => is => ["a"] ],
]);

#my $index;
#check_many(
#        # set
##	[ $set[$index = 0] . "->set(qw 	=> is => "a/b/c" ], 
#        [ $set[++$index]	=> is => "a/b/c" ], 
#        [ $set[++$index]	=> is => "a/b/c" ], 
#        [ $set[++$index]	=> is => "a/b/c" ], 
#        [ $set[++$index]	=> is => "a/b/c" ], 
#        [ "Path::Lite->new->set( qw !a b c! )->get" 			=> is => "a/b/c" ], 
#        [ "Path::Lite->new->set( qw !/a b c! )->get" 			=> is => "/a/b/c" ],
#        [ "Path::Lite->new->set( qw !/a b c/! )->get" 			=> is => "/a/b/c" ],
#        [ "Path::Lite->new->set( qw !/a b c/! )->push( qw !d! )->get"	=> is => "/a/b/c/d" ],
#        [ "Path::Lite->new->set->get"					=> is => "" ],
#        [ "Path::Lite->new->set->push( qw !a/! )->get"			=> is => "a" ],

#        # is_empty 
#        [ "Path::Lite->new->is_empty"					=> is => "1" ],
#        [ "Path::Lite->new( qw!a b c! )->is_empty"			=> is => "" ],
#        [ "Path::Lite->new( qw!a b c! )->set->is_empty"			=> is => "1" ],
#        [ "Path::Lite->new( qw!a b c! )->push( qw!d! )->is_empty"	=> is => "" ],
#        [ "Path::Lite->new( qw!/! )->is_empty"				=> is => "" ],

#        # is_root 
#        [ "Path::Lite->new->is_root"					=> is => "1" ],
#        [ "Path::Lite->new( qw!a b c! )->is_root"			=> is => "" ],
#        [ "Path::Lite->new( qw!a b c! )->set->is_root"			=> is => "1" ],
#        [ "Path::Lite->new( qw!a b c! )->push( qw!d! )->is_root"	=> is => "" ],
#        [ "Path::Lite->new( qw!/! )->is_root"				=> is => "" ],


#        [ "get( qw !/! )"						=> is => "/" ],
#        [ "get( qw !/!, '' )"						=> is => "/" ],
#        [ "join '', get( qw !/!, '' )"					=> is => "/" ],
#        [ "join '', get( '', '' ), ''"					=> is => "" ],
#        [ "Path::Lite->new->set( qw !/a b c/! )->list"			=> is => [ qw/a b c/ ] ],
#);

#is(get(qw(/)), '/');
#is(get(qw(/), ''), '/');
#is(join('', get(qw(/), '')), '/');
#is(join('', get('', '')), '');

#is(path(qw(/apple banana/))->get, '/apple/banana');
#is(path(qw(/apple banana/))->pop->get, '/apple');
#is(path(qw(/apple banana/))->pop(1)->get, '/apple');

#my $index;
#sub next_check {
#sub next_check {
#}

#sub check_many {
#        for (@_) {
#                check(@$_);
#        }
#}

#sub check {
#        my ($stmt, $tst, $tgt, $msg);
#        if (2 == @_) {
#                ($stmt, $tgt) = @_;
#                $tst = $tgt =~ s/^!// ? "isnt" : "is";
#        }
#        else {
#                ($stmt, $tst, $tgt, $msg) = @_;
#        }

#        my $tst_tgt = $tgt;
#        $tst_tgt = objToJson($tgt) if ref $tgt eq 'ARRAY' || ref $tgt eq 'HASH';

#        $msg ||= "$stmt $tst $tst_tgt";

#        my $rslt = ref $tgt eq "ARRAY" ? [ eval $stmt ] : eval $stmt;
#        $tst_rslt = $rslt;
#        $tst_rslt = objToJson($tst_rslt) if ref $tst_rslt eq 'ARRAY' || ref $tst_rslt eq 'HASH';

#        if ($tst eq "is") {
#                is($tst_rslt, $tst_tgt, $msg);
#        }
#}

sub Set_check {
	my ($stmt, $cmpr, $rslt, $msg);
	($stmt, $cmpr, $rslt, $msg) = @_;

	my $xpnd_rslt = $rslt;
	$xpnd_rslt = 'undef' unless defined $rslt;
	$xpnd_rslt = objToJson($rslt) if ref $rslt eq 'ARRAY' || ref $rslt eq 'HASH';

	my $_msg = "$stmt $cmpr $xpnd_rslt";
	if (defined $msg) {
		$msg =~ s/%/$_msg/;
	}
	else {
		$msg = $_msg;
	}

	my $actl_rslt = ref $rslt eq "ARRAY" ? [ eval $stmt ] : eval $stmt;

	my $actl_xpnd_rslt = $actl_rslt;
	$actl_xpnd_rslt = 'undef' unless defined $actl_rslt;
	$actl_xpnd_rslt = objToJson($actl_rslt) if ref $actl_rslt eq 'ARRAY' || ref $actl_rslt eq 'HASH';

	if ($cmpr eq "is") {
		is($actl_xpnd_rslt, $xpnd_rslt, $msg);
	}
}

sub Set_test {
	my $set = shift;
	my $size = @$set;
	my $mdf_set;
	if (ref $_[0] eq 'ARRAY') {
		$mdf_set = shift;
	}
	else {
		my $stmt = shift;
		my $cmpr = shift;
		my $rslt = shift;
		$mdf_set = [ map { [ $stmt, $cmpr, $rslt ] } (0 .. $size - 1) ];
	}

	for (my $index = 0; $index < $size; ++$index) {
		my $line = $set->[$index];
		my $mdf_line = $mdf_set->[$index];

		my $stmt = $mdf_line->[0];
		if (defined $stmt) {
			$stmt =~ s/%/$line->[0]/;
		}
		else {
			$stmt = $line->[0];
		}

		my ($cmpr) = grep { defined } ($mdf_line->[1], $line->[1]);
		my ($rslt) = grep { defined } ($mdf_line->[2], $line->[2]);

		Set_check($stmt, $cmpr, $rslt, "$index: %");
	}

}
