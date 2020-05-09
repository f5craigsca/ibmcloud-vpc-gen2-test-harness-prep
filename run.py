#!/usr/bin/env python

# coding=utf-8
# pylint: disable=broad-except,unused-argument,line-too-long, unused-variable
# Copyright (c) 2016-2018, F5 Networks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
"""
This module contains the logic to create VPC images from
F5 public COS image URLs.
"""

import sys
import os
import shutil
import datetime
import time
import logging
import json
import python_terraform as pt

LOG = logging.getLogger('ibmcloud_vpc_gen2_test_harness_prep')
LOG.setLevel(logging.DEBUG)
FORMATTER = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
LOGSTREAM = logging.StreamHandler(sys.stdout)
LOGSTREAM.setFormatter(FORMATTER)
LOG.addHandler(LOGSTREAM)

API_KEY = None
IMAGE_MATCH = None
ZONES = None

OUTPUT = {}


def apply():
    vpc_path = "%s/vpcs" % os.path.dirname(os.path.realpath(__file__))
    zones = [f.path for f in os.scandir(vpc_path) if f.is_dir()]
    for zone in zones:
        if os.path.basename(zone) in ZONES:
            tf = pt.Terraform(working_dir=zone)
            tf.init()
            LOG.info("running apply on %s" % zone)
            tf.apply(var={'api_key': API_KEY},
                     auto_approve=True, capture_output=False)


def destroy():
    vpc_path = "%s/vpcs" % os.path.dirname(os.path.realpath(__file__))
    zones = [f.path for f in os.scandir(vpc_path) if f.is_dir()]
    for zone in zones:
        if os.path.basename(zone) in ZONES:
            tf = pt.Terraform(working_dir=zone)
            tf.init()
            LOG.info("running destroy on %s" % zone)
            tf.destroy(var={'api_key': API_KEY},
                       auto_approve=True, capture_output=False)


def inventory():
    output = {}
    vpc_path = "%s/vpcs" % os.path.dirname(os.path.realpath(__file__))
    zones = [f.path for f in os.scandir(vpc_path) if f.is_dir()]
    for zone in zones:
        if os.path.basename(zone) in ZONES:
            tf = pt.Terraform(working_dir=zone)
            tf.init()
            zout = tf.output(json=True)
            output[os.path.basename(zone)] = zout
    json_out = json.dumps(output)
    with open("%s/output.json" % os.path.dirname(os.path.realpath(__file__)), 'w') as inventory:
        inventory.write(json_out)


def clean():
    vpc_path = "%s/vpcs" % os.path.dirname(os.path.realpath(__file__))
    zones = [f.path for f in os.scandir(vpc_path) if f.is_dir()]
    for zone in zones:
        tsf = "%s/terraform.tfstate" % zone
        tsfb = "%s.backup" % tsf
        if os.path.exists(tsf):
            os.unlink(tsf)
        if os.path.exists(tsfb):
            os.unlink(tsfb)
        shutil.rmtree("%s/.terraform" % zone, ignore_errors=True)
    output_file = "%s/output.json" % os.path.dirname(
        os.path.realpath(__file__))
    if os.path.exists(output_file):
        os.unlink(output_file)


def initialize():
    global API_KEY, IMAGE_MATCH, ZONES
    API_KEY = os.getenv('API_KEY', None)
    IMAGE_MATCH = os.getenv('IMAGE_MATCH', '^[a-zA-Z]')
    ZONES = os.getenv('ZONES', 'us-south-3')
    ZONES = [x.strip() for x in ZONES.split(',')]


if __name__ == "__main__":
    START_TIME = time.time()
    LOG.debug('process start time: %s', datetime.datetime.fromtimestamp(
        START_TIME).strftime("%A, %B %d, %Y %I:%M:%S"))
    initialize()
    ERROR_MESSAGE = ''
    ERROR = False
    if not API_KEY:
        ERROR = True
        ERROR_MESSAGE += "please set env API_KEY for your IBM IaaS Account\n"
    if ERROR:
        LOG.error('\n\n%s\n', ERROR_MESSAGE)
        sys.exit(1)
    if len(sys.argv) > 1:
        action = sys.argv[1]
    if action.lower() == 'apply':
        apply()
        inventory()
    if action.lower() == 'destroy':
        destroy()
    if action.lower() == 'output':
        inventory()
    if action.lower() == 'clean':
        clean()
    STOP_TIME = time.time()
    DURATION = STOP_TIME - START_TIME
    LOG.debug(
        'process end time: %s - ran %s (seconds)',
        datetime.datetime.fromtimestamp(
            STOP_TIME).strftime("%A, %B %d, %Y %I:%M:%S"),
        DURATION
    )
