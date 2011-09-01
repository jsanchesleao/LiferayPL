package Flanelinha::Client;
use Moose;
use Mojo::UserAgent;

has ua  => (is => "rw", isa => "Mojo::UserAgent", default => sub{Mojo::UserAgent->new});
has url => (is => "rw", isa => "Str", default => "http://localhost:3000");

sub portlet {
   my $self = shift;
   if(@_ > 1) {
      my %pars = @_;
      return $self->ua->post_form($self->url . "/portlet/$pars{namespace}" => {%pars})->res->code == 200
   } elsif(@_ == 1) {
      my $namespace = shift;
      return $self->ua->get($self->url . "/portlet/$namespace")->res->json->{obj}
   } else {
      die "'" . ref($self) . "->portlet' should receive at least 1 parameter";
   }
}

42
