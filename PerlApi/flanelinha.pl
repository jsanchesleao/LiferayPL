#!/usr/bin/perl

use Mojolicious::Lite;

my %portlet;

under "/portlet/:namespace" => sub {
   my $self = shift;
   app->log->debug("namespace: " . $self->stash->{namespace});
   if(exists $portlet{$self->stash->{namespace}}) {
      $self->stash->{portlet} = $portlet{$self->stash->{namespace}};
   } else {
      $self->stash->{portlet} = {};
      $portlet{$self->stash->{namespace}} = $self->stash->{portlet};
   }
};

post "/" => sub{
   my $self = shift;
   $self->stash->{portlet}->{$_} = $self->req->params->to_hash->{$_} for keys %{ $self->req->params->to_hash };

   $self->render_json(1)
} => undef;

get "/" => sub{
   my $self = shift;

   $self->render_json( { name => $self->stash->{namespace}, obj => $self->stash->{portlet} } )
} => undef;

del "/" => sub{
   my $self = shift;

   delete $portlet{$self->stash->{namespace}};
   $self->render_json(1)
} => undef;

post "/log" => sub{
   my $self = shift;
   my $msg = $self->param("msg");
   app->log->debug($self->stash->{portlet}->{namespace} . ": " . $msg);
   $self->render_json(1)
} => undef;

app->start;
