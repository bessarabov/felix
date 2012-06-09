#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
create_symlinks — создание симлинков пользовательского окружения.

Этот скрипт на все файлы, которые есть в ~/felix/tilde, создаёт
симлинки в ~.

Скрипт умирает, если уже есть файл, который скипт хочет создать.
Или симлинк уже есть, но он указывет не туда, куда нужно.

Запускать это нужно как-то так:
    $ cd
    $ ./felix/create_symlinks
"""

from __future__ import print_function
import logging
import os
import os.path
import sys

logging.getLogger().name = __name__
if '-v' in sys.argv:
    logging.basicConfig(level=logging.INFO)

tilde = 'felix/tilde'
home = os.getcwd()

try:
    for file in sorted(os.listdir(tilde)):
        felix_object = os.path.join(tilde, file)
        home_object = os.path.join(home, file)
        logging.info('Found %s "%s"' % ('directory' if os.path.isdir(file) else 'file', file))
        if os.path.islink(home_object):
            target = os.readlink(home_object)
            if target == felix_object:
                logging.info('\tA correct symlink already exists')
            else:
                raise Exception(
                    'The symlink "%s" points to\n'
                    '"%s" but it is expected to point to\n'
                    '"%s"'
                    % (home_object, target, felix_object)
                )
        elif os.path.exists(home_object): # and not a link
            raise Exception(
                'There is already a file "%s" which is not a symbolic link to\n'
                '"%s"'
                % (home_object, felix_object)
            )
        else:
            logging.info('\tCreating symlink')
            os.symlink(felix_object, home_object)
    logging.info('End')
except Exception, e:
    logging.error(type(e).__name__ + ':')
    for line in e.message.splitlines():
        logging.error('\t' + line)
    sys.exit(1)
