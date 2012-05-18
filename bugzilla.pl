use BZ::Client;
use Data::Dumper;


my $url= 'https://bugzilla.internal.jibe.com';
my $user= 'apatil';
my $password= '';

 
   my $client = BZ::Client->new("url" => $url,
                               "user" => $user,
                               "password" => $password);
  

eval { $client->login() };
if($@) 
{ 
    if( ref $@ ) 
    {
        print "first loop"
        print Dumper($@);    
    }
    else {
        print "second loop"
        print Dumper($@);
    }
}