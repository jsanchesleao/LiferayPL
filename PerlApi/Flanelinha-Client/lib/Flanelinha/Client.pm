package Flanelinha::Client;
use Moose;
use Mojo::UserAgent;

has ua        => (is => "rw", isa => "Mojo::UserAgent", default => sub{Mojo::UserAgent->new});
has url       => (is => "rw", isa => "Str", default => "http://localhost:3000");
has namespace => (is => "rw", isa => "Str", required => 1);
has "log"     => (is => "ro", isa => "Flanelinha::Client::Log", lazy => 1,
                  default => sub {
                     my $self = shift;
                     Flanelinha::Client::Log->new(
                        ua        => $self->ua,
                        url       => $self->url,
                        namespace => $self->namespace,
                     )
                  });

sub portlet {
   my $self = shift;
   my $namespace = $self->namespace;
   if(@_ > 0) {
      my %pars = @_;
      return $self->ua->post_form($self->url . "/portlet/$namespace" => {namespace => $namespace, %pars})->res->code == 200
   } else {
      return $self->ua->get($self->url . "/portlet/$namespace")->res->json->{obj}
   }
}

package Flanelinha::Client::Log;
use Moose;

extends "Flanelinha::Client";

has "+ua"         => (required => 1);
has "+url"        => (required => 1);
has "+namespace"  => (required => 1);

override log => sub{
   die "You cannot use log of a log"
};

sub send_log {
   my $self  = shift;
   my $level = shift;
   my $msg   = shift;
   my $namespace = $self->namespace;
   return $self->ua->post_form($self->url . "/portlet/$namespace/log" => {level => $level, msg => $msg})->res->code == 200
}

sub trace {
   shift()->send_log("TRACE" => shift);
}

sub info {
   shift()->send_log("INFO" => shift);
}

sub debug {
   shift()->send_log("DEBUG" => shift);
}

sub warn {
   shift()->send_log("WARN" => shift);
}

sub error {
   shift()->send_log("ERROR" => shift);
}


42
