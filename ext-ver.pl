#!/usr/bin/perl
use strict;
use warnings;

use URI;
use Encode;
use Web::Scraper;
use Term::ANSIColor;
use LWP::Simple;

my $dlUrl = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=75.0&x=id%3D%s%26installsource%3Dondemand%26uc"; # %s needs to be replaced

my @urls = (
    "https://chrome.google.com/webstore/detail/4chan-x/ohnjgmpcibpbafdlkimncjhflgedgpam", # 4chan x
    "https://chrome.google.com/webstore/detail/clearurls/lckanjgmijmafbedllaakclkaicjfmnk", #ClearURLs
    "https://chrome.google.com/webstore/detail/decentraleyes/ldpochfccmkkmhdbclfhpagapcfdljkj", # Decentraleyes
    "https://chrome.google.com/webstore/detail/new-tab-redirect/icpgjfneehieebagbmdbhnlpiopdcmna", # New Tab Redirect
    "https://chrome.google.com/webstore/detail/privacy-badger/pkehgijcmpdhfbdbbnkijodmdjhbjlgp", # Privacy Badger
    "https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne", # Stylus
    "https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo", # Tampermonkey
    "https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm", # ublock origin
    "https://chrome.google.com/webstore/detail/ublock-origin-extra/pgdnlhfefecpicbbihgmbmffkjpaplco", # ublock origin extra
);

my @urlNames = (
    "4chan X",
    "ClearURLs",
    "Decentraleyes",
    "New Tab Redirect",
    "Privacy Badger",
    "Stylus",
    "Tampermonkey",
    "uBlock origin",
    "uBlock origin extra",
);

my $handle;
my $file = "installed_version.txt";
unless (open $handle, "<", $file) {
    print STDERR "Could not open file";
    return undef;
}

chomp (my @lines = <$handle>);
close $handle;

my $version = scraper {
    process_first ".C-b-p-D-Xe.h-C-b-p-D-md", ver => 'TEXT';
};

for my $i (0 .. $#urls) {
    my $url = $urls[$i];
    my $res = $version->scrape(URI->new($url));
    print "$urlNames[$i]: $lines[$i] -> ";

    if ($res->{ver} eq $lines[$i]) {
        print color('green');
    } else {
        print color('red');

        my $slashPos = rindex($url, '/');
        my $extId = substr($url, $slashPos + 1);

        my $dlUrlextId = $dlUrl;
        $dlUrlextId =~ s/%s/$extId/i;

        my $dlFile = "./downloads/$urlNames[$i].crx";
        getstore($dlUrlextId, $dlFile);

        $lines[$i] = $res->{ver};
    }

    print "$res->{ver}\n";
    print color('reset');
}

unless (open $handle, '>', $file) {
    print STDERR "Could not open file";
    return undef;
}

foreach (@lines) {
    print $handle "$_\n";
}

close($handle);