#!/usr/bin/env sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
app_path=$0

# Need this for daisy-chained symlinks.
while
    APP_HOME=${app_path%"${app_path##*/}"}
    [ -h "$app_path" ]
do
    app_path=$( readlink -f "$app_path" )
done

APP_HOME=$( cd "${APP_HOME:-.}" && pwd -P ) || exit

# This is normally unnecessary, but use it if this script is generated in a
# directory where the shell is unable to find Gradle.
if [ -z "$GRADLE_HOME" ] ; then
    GRADLE_HOME="$APP_HOME/gradle"
fi

# Add default JVM options here.
DEFAULT_JVM_OPTS='-Xmx64m -Xms64m'

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        echo "Error: JAVA_HOME is not defined correctly." >&2
        echo "  We cannot execute $JAVACMD" >&2
        exit 1
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || {
        echo "Error: JAVA_HOME is not set and no 'java' command could be found in your PATH." >&2
        exit 1
    }
fi

# For Cygwin or MSYS, switch paths to Windows format before running java
cygwin=false
msys=false
darwin=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MSYS* | MINGW* )
    msys=true
    ;;
esac

if [ "$cygwin" = "true" -o "$msys" = "true" ] ; then
    APP_HOME=`cygpath --path --mixed "$APP_HOME"`
    CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`

    JAVACMD=`cygpath --mixed "$JAVACMD"`

    for arg in "$@" ; do
        if expr "$arg" : '\(.*\)\.jar$' > /dev/null ; then
            arg=`cygpath --path --mixed "$arg"`
        fi
        CMD="$CMD \"$arg\""
    done
    eval set -- $CMD
fi

CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar

exec "$JAVACMD" $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"
