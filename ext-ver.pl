#!/usr/bin/perl
use strict;
use warnings;

use URI;
use Web::Scraper;
use Encode;

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

my $version = scraper {
    process_first ".C-b-p-D-Xe.h-C-b-p-D-md", ver => 'TEXT';
};

for my $i (0 .. $#urls) {
    my $res = $version->scrape(URI->new($urls[$i]));
    print Encode::encode("utf8", "$urlNames[$i]: $res->{ver}\n");
}