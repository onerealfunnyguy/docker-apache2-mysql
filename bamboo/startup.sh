#!/bin/bash
phantomjs --webdriver=4444 &
/opt/atlassian/bamboo/bin/start-bamboo.sh -fg
