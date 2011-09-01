#!/usr/bin/perl

use Mojolicious::Lite;

my %portlet;
my @logs;

my %log_dic = (
   TRACE => 5,
   DEBUG => 4,
   INFO  => 3,
   WARN  => 2,
   ERROR => 1,
);

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
   my $level = $self->param("level");
   my $msg   = $self->param("msg");
   push @logs, {level => $level, msg => $msg};
   app->log->log($level, $self->stash->{namespace} . ": $msg");
   $self->render_json(1)
} => undef;

get "/log" => sub{
   my $self = shift;
   my @logs_local = @logs;
   @logs = ();
   $self->render_json(\@logs_local)
};

get "/log/:loglevel" => sub{
   my $self = shift;
   app->log->debug("Log level: " . $self->stash->{loglevel});
   my @logs_local = grep {
      app->log->debug(" -> " . $_->{level});
      $log_dic{$_->{level}} <= $log_dic{$self->stash->{loglevel}}
   } @logs;
   @logs = ();
   $self->render_json(\@logs_local)
};

websocket "/logreader/:loglevel" => sub{
   my $self = shift;
   app->log->debug("websocket conectado!");
   $self->on_message(sub{
      my ($self, $message) = @_;
      $self->send_message($message);
      app->log->debug("ws: " . $message);
   });
};

app->start;
