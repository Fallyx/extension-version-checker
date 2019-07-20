#!/usr/bin/perl
use strict;
use warnings;

use URI;
use Encode;
use JSON;
use File::Slurp;
use Web::Scraper;
use Term::ANSIColor;
use LWP::Simple;
use Net::DBus;

my $notify_update = 0;

my $json_file = 'extensions.json';
my $json_file_content = read_file($json_file);
my $decoded_extensions_ref = decode_json($json_file_content);
my %decoded_extensions = %$decoded_extensions_ref;

my $chrome_version = $decoded_extensions{'chrome-version'};

# %s needs to be replaced
my $dl_url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=$chrome_version&x=id%3D%s%26installsource%3Dondemand%26uc";

my $version_scraper = scraper {
    process_first ".C-b-p-D-Xe.h-C-b-p-D-md", ver => 'TEXT';
};

foreach my $ext_name (keys %{ $decoded_extensions{extensions} }) {
    my $url = $decoded_extensions{extensions}{$ext_name}{url};
    my $version = $decoded_extensions{extensions}{$ext_name}{version};
    my $web_version = $version_scraper->scrape(URI->new($url));
    print "$ext_name $version -> ";

    if ($web_version->{ver} eq $version) {
        print color('green');
    } else {
        print color('red');
        my $slash_pos = rindex($url, '/');
        my $ext_id = substr($url, $slash_pos + 1);

        my $dl_url_ext = $dl_url;
        $dl_url_ext =~ s/%s/$ext_id/i;

        my $dl_file = "./extension-files/$ext_name.crx";
        if(!(-e "./extension-files")) {
            mkdir "./extension-files";
        }
        getstore($dl_url_ext, $dl_file);

        $decoded_extensions{extensions}{$ext_name}{version} = $web_version->{ver};
        $notify_update = 1;
    }

    print "$web_version->{ver}\n";
    print color('reset');
}

my $encode_extensions = encode_json \%decoded_extensions;
write_file($json_file, $encode_extensions);

if ($notify_update) {
    my $bus = Net::DBus->session;
    my $srvc = $bus->get_service('org.freedesktop.Notifications');
    my $obj = $srvc->get_object('/org/freedesktop/Notifications');
    my $id = $obj->Notify(
        'ext-ver',
        0,
        'dialog-information',
        'Extensions outdated',
        "There is an update for one or more installed extensions.",
        [],
        {},
        5000
    );
}