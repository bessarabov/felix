#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF-8
=cut

=head1 Название

create_symlinks.pl - создание симлинков пользовательского окружения

=head1 Описание

В гит репозитарии содержатся файлы, которые должны быть в ~/
Скрипт create_symlinks.pl проходит все файлы в папке tilde,
проверяет что нет такого файла в ~/ и создает симлинк из tilde в ~/

Вообщем это скрипт на все файлы которые есть в ~/felix/tilde создает
симлинки в ~.

Скрипт умирает если уже есть файл, который скипт хочет создать.
Или симлин уже есть, но он указывет не туда куда нужно.

Запускать это нужно как-то так:

    cd
    ./felix/create_symlinks.pl


=cut

use File::Find;

my $dir = "felix/tilde";
my $home = `pwd`;
chomp($home);

sub wanted {

    my $file = $File::Find::name;
    $file =~ s{^$dir/?}{};

    if (-d $File::Find::name) {
        return if $file eq '';
        print "Found directory '$file'\n";

        unless (-d "$home/$file") {
            print " Creating dir\n";
            `mkdir $home/$file`;
        }

        return;
    };

    print "Found '$file' in $dir\n";

    if ( -f "$home/$file" )  {

        if ( -l "$home/$file" )  {
            my $symlink = readlink( "$home/$file" );

            if ($symlink eq "$home/$dir/$file") {
                print " There is already correct symlink\n";
            } else {
                die " ! Fatal symlink points to '$symlink'\n";
            };
        } else {
            die "! Fatal file $home/$file exist\n";
        }

    } else {
        print " Creating symlink\n";
        symlink "$home/$dir/$file", "$home/$file";
    }
}

find({ wanted => \&wanted, no_chdir => 1 }, $dir);

print "End\n";
