use Test::More "no_plan";
require LWP::UserAgent;
use JSON::XS;
use Net::MySQL;


my $u1= $ARGV[0];
my $j_env=0;
my $u_env=0;
my $d_env=0;
my $user=0;
my $password=0;
my $database=0;
if ($u1 =~ m/stg/)
{
	$j_env="209.114.35.61:8080";
        $u_env="jibeqa:jibejibe1124\@jibe.testbacon.com";
	$d_env="jibe.testbacon.com"; 
        $database = 'jibe_staging';
        $user     = 'toby';
        $password = 'uLT9L5BsVxBQDpFJ';
}
elsif ($u1 =~ m/prd/)
{
	$j_env="jobservice1.jibe.com:8080";
  $u_env="www.jibe.com";
	$d_env= "mysqls-03.jibe.com";#"174.143.141.119";
	$database = 'jibe_production';
	$user     = 'readonly';
	$password = 'r3ad0nly1124';
}



get_id_from_active();

   
sub check_against_db
{
    my ($tmp_id) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(3);
    $ua->env_proxy; 
    my $response = $ua->get("http://$j_env/jobs/id/$tmp_id.json");
    my $actual_response=$response->decoded_content;
    my $perl_scalar = decode_json($actual_response);
    my $title= $perl_scalar->[0]->{title};
    my $full_description=$perl_scalar->[0]->{full_description};
    my $id=$perl_scalar->[0]->{id};
    my $company_id=$perl_scalar->[0]->{company_id};
    my $credits=$perl_scalar->[0]->{credits};
    check_db($title,$full_description,$id,$company_id,$credits);
}

sub get_id_from_active
{	
    my $ua = LWP::UserAgent->new;
    $ua->timeout(3);    
    $ua->env_proxy;
    my $response = $ua->get("http://$j_env/jobs/all.json?status=active");
    my $actual_response=$response->decoded_content;
    my $perl_scalar = decode_json($actual_response);
    my $counter = @{$perl_scalar};
    --$counter;
    while ($counter>=0)
    {
	$company_id= $perl_scalar->[$counter]->{company_id};
	my $response1 = $ua->get("http://$j_env/jobs/all.json?company=$company_id");
	my $actual_response1=$response1->decoded_content;
	my $perl_scalar1 = decode_json($actual_response1);
	my $counter1 = @{$perl_scalar1};
	--$counter1;
	while ($counter1>=0)
	{
	    $id= $perl_scalar1->[$counter1]->{id};
	    check_against_db($id);
	    --$counter1;
	};
    $counter--;	
    };
}

sub check_db
{
  my ($tmp_title,$tmp_full_description,$tmp_id,$tmp_company_id,$tmp_credits) = @_;
  my $mysql = Net::MySQL->new(
      hostname => "$d_env", 
      database => "$database",
      user     => "$user",
      password => "$password",
      timeout => 120,
  );
  $mysql->query("select title,full_description,company_id,credits from jobs where id = $tmp_id");
  if ($mysql->has_selected_record)
    {
	my $record_set = $mysql->create_record_iterator;
	while(my $record = $record_set->each)
        {
          my $db_title= $record->[0];
          my $db_full_description= $record->[1];
          my $db_company_id= $record->[2];
          my $db_credits= $record->[3];
	  ok($db_title=~m/\Q$tmp_title/,"The job's Title parsed by the JSON call does not match the Title displayed in the DB.");
	  ok($db_full_description = $tmp_full_description,"The job's Full Description parsed by the JSON call does not match the Title displayed in the DB.");
	  ok($db_company_id=~m/\Q$tmp_company_id/,"The job's Company Id parsed by the JSON call does not match the Company Id displayed in the DB.");
	}
    }
$mysql->close;
}
exit();


