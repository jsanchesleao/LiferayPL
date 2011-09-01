#!/usr/bin/perl

use Mojolicious::Lite;

my %portlet;
post "/portlet/:namespace" => sub{
   my $self = shift;
   $portlet{$self->stash->{namespace}}->{$_} = $self->req->params->to_hash->{$_} for keys %{ $self->req->params->to_hash };

   $self->render_json(1)
} => undef;

get "/portlet/:namespace" => sub{
   my $self = shift;

   $self->render_json( { name => $self->stash->{namespace}, obj => $portlet{$self->stash->{namespace}} } )
} => undef;

del "/portlet/:namespace" => sub{
   my $self = shift;

   delete $portlet{$self->stash->{namespace}};
   $self->render_json(1)
} => undef;

app->start;
