#!/usr/bin/perl

{
   package Portlet;
   use Moose;
}

package main;

use Mojolicious::Lite;

my %portlet;

put "/portlet/:namespace" => sub{
   my $self = shift;
   $portlet{$self->stash->{namespace}} = Portlet->new($self->param);

   $self->render_json(1)
};

app->start;
