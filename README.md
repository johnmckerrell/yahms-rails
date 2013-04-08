# Yet Another Home Management System (YAHMS)

Welcome to the server component of the YAHMS system, Arduino code is here:

https://github.com/johnmckerrell/YAHMS

This is a standard rails (3) app and should be much like other rails apps
to get going.

The system is very very basic and offers the bare minimum functionality
needed to use it. Creating a new system currently requires manually
adding entries to the database (or using the console). Hopefully this will
change in the future.

## OpenShift

The openshift branch should allow you to create your own OpenShift "app"
and get a yahms instance running with very little effort.

Currently there's a bug in deployment to OpenShift. Once you have pushed
your code you will need to ssh into your OpenShift applicateion and
perform the following commands:

    cd app-root/runtime/repo/
    bundle exec rake assets:precompile
    touch tmp/restart.txt

## License

Code originally Copyright John McKerrell
Licensed under The Artistic License 2.0, a copy of which should be in the
root of the repository named "LICENSE".
