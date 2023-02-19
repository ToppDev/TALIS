#!/bin/sh
# This is a -*- shell-script -*- fragment called by /etc/X11/Xsession

# Redirect all errors to /dev/null instead of $ERRFILE
# (~/.xsession-errors by default), to avoid filling up users home
# directory with error messages.  Allow the user to disable this by
# creating ~/.xsession-errors-enable

if [ ! -f "$HOME/.xsession-errors-enable" ] ; then

  rm -f $HOME/.xsession-errors
  ln -s /dev/null $HOME/.xsession-errors

  # Report the change to the log file before switching
  echo "info: Redirecting xsession messages to /dev/null."
  echo "info: touch '$HOME/.xsession-errors-enable' to disable this."
  exec >> /dev/null 2>&1
fi