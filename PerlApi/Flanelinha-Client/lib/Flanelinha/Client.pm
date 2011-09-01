package Flanelinha::Client;
use Moose;
use Mojo::UserAgent;

has ua        => (is => "rw", isa => "Mojo::UserAgent", default => sub{Mojo::UserAgent->new});
has url       => (is => "rw", isa => "Str", default => "http://localhost:3000");
has namespace => (is => "rw", isa => "Str", required => 1);

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

42
