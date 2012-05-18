use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::More "no_plan";
use Test::Exception;
require LWP::UserAgent;
use JSON::XS;
use Data::Dumper;


my ($u1, $u2) = @ARGV;
my ($app_id, $api_key, $app_secret_key, $app_access_token, $env, $browser, $ttemp); 
my $ua = LWP::UserAgent->new;
$ua->timeout(30);    
$ua->env_proxy;
my $ua1 = LWP::UserAgent->new;
$ua1->timeout(30);    
$ua1->env_proxy;
my $new_password= "jibejibe1124";

if ($u1 =~ m/prd/)
{
  $env="http://www.jibe.com/";
  $app_id='240782195996';
  $api_key='5bb7085082a9ff2ac6dedb8268f71671';
  $app_secret_key='858b3ce026c8bb0415bbcf4919bbdf31';
  $app_access_token='240782195996|XAbHsnO0zlltKhBlCLZTQrSakDc';
}
elsif ($u1 =~ m/stg/)
{
  $env="http://jibeqa:jibejibe1124\@jibe.testbacon.com/";
  $app_id='369631730805';
  $api_key='3ff781046f7d5ff876e91d1e9b10be1d';
  $app_secret_key='6ec65ec9b12fabb9c2054f05e02b7e43';
  $app_access_token='369631730805|s0I8x7xGwLoEcgB-jtRrB8H03IA';
}

my @test_user;

# Delete all test users at the start of the script    
#delete_all_test_users();
start_testing();

sub start_testing
{
    # Create Test Users
    for (my $j=0; $j<$u2; $j++)
    {generate_test_user($j);}
    
    # Make connections all to all
    if ($u2>1)
    {
    my $location=1;
    #foreach (@test_user)
    #{
    #    make_friend_connections($_,$location);
    #    $location++;
    #}
    make_friend_connections($test_user[0],$location);
    @{$test_user[0]{name_of_friends}} = sort(@{$test_user[0]{name_of_friends}});
    }
    foreach (@test_user)
    {   
      my $i=$_;
      change_password($i);
      print "\n\n--+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+--\n";
      print "The email for the test user login is $i->{email}\n";
      print "The password for the test user login is $i->{password}\n";
      print "The number of friends the test user has: $i->{number_of_friends}\n";
      print "The user id is: $i->{id} \n";
      print "\n--+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+--\n\n";
    }
    
}    


# Generate App Access Token
sub generate_app_access_token
{
    $app_access_token = "https://graph.facebook.com/oauth/access_token?
    client_id=$app_id&client_secret=$app_secret_key&
    grant_type=client_credentials";
}


# Generate a test user
sub generate_test_user
{
    my ($i) = @_;
    my $first_name=generate_random_string();
    my $response = $ua->get("https://graph.facebook.com/$app_id/accounts/test-users?installed=true&name=$first_name&permissions=read_stream&method=post&access_token=$app_access_token");
    my $actual_response=$response->decoded_content;
    $test_user[$i] = decode_json($actual_response);
    $test_user[$i]{first_name} =$first_name;
    $test_user[$i]{number_of_friends} =0;
    
    #$test_user[$i]{name_of_friends} = 0;

    if ($test_user[$i]{id})
    {
      ok(1,"$test_user[$i]{email} is created successfully and is stored in the [$i] spot in test_users array");
      #change_password($test_user[$i]{id});
    }
    else
    {ok(0,"Test User number: $i did not get created");}
}

# Generate a random string
sub generate_random_string
{
  my $length_of_randomstring=1;
  my @chars=('a'..'z','A'..'Z');
  my $random_string;
  foreach (1..$length_of_randomstring) 
  {$random_string.=$chars[rand @chars];}
  return $random_string;
}


# Make friend connections
sub make_friend_connections
{
  my ($user,$location1) = @_;
  my $location2=1;
  foreach (@test_user)
  {
    my $tmp=$_;
    if($location1 < $location2)
    {
        my $connection= $ua->get("https://graph.facebook.com/$user->{id}/friends/$tmp->{id}?method=post&access_token=$user->{access_token}");
        my $actual_response=$connection->decoded_content;
        if ($actual_response !~ m/error/ig)
        {
            ok(1,"The Test User email 1 = $user->{email} successfully sends a request to test user email 2 = $tmp->{email}");
            my $connection1= $ua->get("https://graph.facebook.com/$tmp->{id}/friends/$user->{id}?method=post&access_token=$tmp->{access_token}");
            my $actual_response1=$connection1->decoded_content;
            if ($actual_response !~ m/error/ig)
            {
                ok(1,"The Test User email 2 = $tmp->{email} successfully ACCEPTED a request sent by user email 1 = $user->{email}");
                $user->{number_of_friends} +=1;
                $tmp->{number_of_friends} +=1;
                push(@{$user->{name_of_friends}}, $tmp->{first_name});
                push(@{$tmp->{name_of_friends}}, $user->{first_name});
            }
            else
            {
                ok (0,"The Test User email 2 = $tmp->{email} FAILS TO ACCEPT a request sent by test user email 1 = $user->{email} ");
            }
        }
        else
        {ok (0,"The Test User email 1 = $user->{email} FAILS TO send a request to test user email 2 = $tmp->{email} ");sleep(5);}
        
    }
   $location2++; 
  }
}

# Delete a test suer
sub delete_test_user
{
  my ($user) = @_;
  my $delete_user= $ua->get("https://graph.facebook.com/$user?method=delete&access_token=$app_access_token");
}

#Delete all test users
sub delete_all_test_users
{
  print "Deleting old test users... \n";
  START:
  my $delete_all= $ua->get("https://graph.facebook.com/$app_id/accounts/test-users?access_token=$app_access_token");
  my $actual_response=$delete_all->decoded_content;
  my $perl_scalar = decode_json($actual_response);
  my $counter=@{$perl_scalar->{data}};
  if ($counter > 0)
  {
    for (my $i=0; $i<$counter; $i++)
    {
      if ($perl_scalar->{data}->[$i]->{id} == 100003738461531)
      {goto FINISH;}
      delete_test_user($perl_scalar->{data}->[$i]->{id});
    }
    print "Be patient there were too many old test users.\n";
    goto START;
  }
  FINISH:
  print "Old test users have been deleted.\nNew test users will now be created.\n\n\n";
}

sub change_password
{
  my ($user) =@_;  
  my $response = $ua1->get("https://graph.facebook.com/$user->{id}?password=$new_password&method=post&access_token=$app_access_token"); 
  if ($response->is_success) 
  { $user->{password}="$new_password";}
  else { ok (0,"The password for $user->{id} could not be changed"); }
}