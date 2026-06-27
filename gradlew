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
# distributed under the License is distributed on an "AS IS" IS" BASIS,
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
    APP_HOME=${app_path%"${app_path##*/}"}  # leaves a trailing /; empty if no leading path
    [ -h "$app_path" ]
do
    app_path=$( readlink -f "$app_path" )
done

APP_HOME=$( cd "${APP_HOME:-.}" && pwd -P ) || exit

# This is normally unnecessary, but use it if this script is generated in a
# directory where the shell is unable to find Gradle.
# You can also use this if you want to force the use of a particular version
# of Gradle.
if [ -z "$GRADLE_HOME" ] ; then
    GRADLE_HOME="$APP_HOME/gradle/gradle-8.0"
fi

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS='" -Xmx64m" "-Xms64m"'

# Use the maximum available, or set MAX_FD != infinity.
if ! expr "$MAX_FD" : '[0-9]\+$' > /dev/null; then
    MAX_FD=maximum
fi

# Increase the maximum file descriptors if we can.
if ! [ "$MAX_FD" = unlimited ] ; then
    max_user_fd=$(ulimit -H -n)
    if [ "$max_user_fd" = unlimited ] || [ "$max_user_fd" -gt 900000 ]; then
        ulimit -n 900000
    else
        ulimit -n "$max_user_fd"
    fi
fi

# Collect all arguments for the java command, stacking in reverse order:
#   * args from the command line
#   * the main class name
#   * -classpath
#   * -D...appname settings
#   * --module-path (only if needed)
#   * DEFAULT_JVM_OPTS, JAVA_OPTS, and GRADLE_OPTS environment variables.

# For Cygwin or MSYS, switch paths to Windows format before running java
if ! expr "$0" : '/' > /dev/null; then
    app_path=`cygpath --path --mixed "$0"`
    APP_HOME=`cygpath --path --mixed "$APP_HOME"`
    CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`

    JAVACMD=`cygpath --mixed "$JAVACMD"`

    for arg in "$@" ; do
        if expr "$arg" : '\(.*\)\.jar$' > /dev/null ; then
            arg=`cygpath --path --mixed "$arg"`n        fi
        args="$args \"$arg\""
    done
fi

#
# Add default JVM options here. You can also use JAVA_OPTS to pass JVM options to this script.
#
# The default value of DEFAULT_JVM_OPTS uses the arrival of a 64-bit system property to trigger
# "server" mode unless users explicitly request client mode.
#
if [ "$( expr \( \( "$os_64" = true \) -o \( "$os_arch" = "x86_64" \) \) )" = "true" ] ; then
    DEFAULT_JVM_OPTS='" -server " -Xmx64m" "-Xms64m"'
else
    DEFAULT_JVM_OPTS='" -client " -Xmx32m" "-Xms32m"'
fi

JAVA_OPTS="${JAVA_OPTS:-}${DEFAULT_JVM_OPTS:+ $DEFAULT_JVM_OPTS}"

# Escape application args
JAVA_OPTS="$JAVA_OPTS ${GRADLE_OPTS:+ $GRADLE_OPTS}"

# Collect all arguments for the java command, stacking in reverse order
for arg in "$@"
do
    args="$args \"$arg\""
done

# Call the Gradle CLI entrypoint
eval "exec \"$JAVACMD\" $JAVA_OPTS -classpath \"$CLASSPATH\" org.gradle.wrapper.GradleWrapperMain " "$args"
