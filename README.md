IMPORTANT!!! Collectd 5.1+ comes with a C-based graphite plugin. I would recommend using that as it will be maintained 
going forward as part of collectd. More info here: http://collectd.org/wiki/index.php/Plugin:Write_Graphite

Collectd-Graphite Plugin
========================

This plugin acts as bridge between collectd's huge base
of available plugins and graphite's excellent graphing
capabilities. It sends collectd data directly
to your graphite server.

It is implemented using the [collectd-perl](http://collectd.org/documentation/manpages/collectd-perl.5.shtml)
interface.

This plugin was inspired by the great [collectd-to-graphite](https://github.com/loggly/collectd-to-graphite)
tool written by the prolific engineer Jordan Sissel at Loggly.
Jordan's implementation uses an external process to bridge
collectd to graphite. I did not want another process to
manage or worry about, so I wrote a plugin for collectd
instead.


REQUIREMENTS
------------
Because the plugin requires the [Globals](http://collectd.org/wiki/index.php/Plugin:Perl#Globals) 
option to be set to true, you will need at least version 4.9 of collectd.
If you are using an older version, you'll have to compile with global visibility of symbols.

As of version 3, the plugin should work fine with collectd 5.0 as well.

This is the command to compile collectd with global visibility symbols:

	./configure CFLAGS="-DLT_LAZY_OR_NOW='RTLD_LAZY|RTLD_GLOBAL'"
	make all install


INSTALLATION
------------

Make sure collectd and the collectd-perl module are installed.

This was tested on CentOS 5 using the "collectd-4.10" and 
"perl-Collectd-4.10" rpm's from the EPEL yum repo.

Feedback on installing on other platforms is welcome.

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install

Collectd 4.10.3 on RHEL5 / CentOS 5 errors
------------------------------------------

( Thanks to https://github.com/indygreg/collectd-carbon for this info which also affects collectd perl plugins. )

Using the plugin with collectd-4.10.3 from EPEL5 on RHEL or CentOS 5.x may produce the following error:

    # /etc/init.d/collectd start
    Starting collectd: plugin_load_file: The global flag is not supported, libtool 2 is required for this.
    perl: Initializing Perl interpreter...
    Can't load '/usr/lib64/perl5/5.8.8/x86_64-linux-thread-multi/auto/threads/threads.so' for module threads: /usr/lib64/perl5/5.8.8/x86_64-linux-thread-multi/auto/threads/threads.so: undefined symbol: PL_no_mem at /usr/lib64/perl5/5.8.8/x86_64-linux-thread-multi/DynaLoader.pm line 230.
     at /usr/lib/perl5/vendor_perl/5.8.8/Collectd.pm line 27
    Compilation failed in require at /usr/lib/perl5/vendor_perl/5.8.8/Collectd.pm line 27.
    BEGIN failed--compilation aborted at /usr/lib/perl5/vendor_perl/5.8.8/Collectd.pm line 27.
    Compilation failed in require.
    BEGIN failed--compilation aborted.
    perl: init_pi: Unable to bootstrap Collectd: Can't load '/usr/lib64/perl5/5.8.8/x86_64-linux-thread-multi/auto/threads/threads.so' for module threads: /usr/lib64/perl5/5.8.8/x86_64-linux-thread-multi/auto/threads/threads.so: undefined symbol: PL_no_mem at /usr/lib64/perl5/5.8.8/x86_64-linux-thread-multi/DynaLoader.pm line 230.
     at /usr/lib/perl5/vendor_perl/5.8.8/Collectd.pm line 27
    Compilation failed in require at /usr/lib/perl5/vendor_perl/5.8.8/Collectd.pm line 27.
    BEGIN failed--compilation aborted at /usr/lib/perl5/vendor_perl/5.8.8/Collectd.pm line 27.
    Compilation failed in require.
    BEGIN failed--compilation aborted
    perl: Configuration failed with a fatal error - plugin disabled!
    
This may also occur on other operating systems. It is caused by a libtool/libltdl quirk described in [this mailing list thread](http://mailman.verplant.org/pipermail/collectd/2008-March/001616.html). As per the workarounds detailed there, you may either:

 1. Modify the init script.

        @@ -25,7 +25,7 @@
                echo -n $"Starting $prog: "
                if [ -r "$CONFIG" ]
                then
        -               daemon /usr/sbin/collectd -C "$CONFIG"
        +               LD_PRELOAD=/usr/lib64/perl5/5.8.8/x86_64-linux-thread-multi/CORE/libperl.so daemon /usr/sbin/collectd -C "$CONFIG"
                        RETVAL=$?
                        echo
                        [ $RETVAL -eq 0 ] && touch /var/lock/subsys/$prog

 1. Modify the RPM and rebuild.

        @@ -182,7 +182,7 @@


         %build
        -%configure \
        +%configure CFLAGS=-"DLT_LAZY_OR_NOW='RTLD_LAZY|RTLD_GLOBAL'" \
             --disable-static \
             --disable-ascent \
             --disable-apple_sensors \

CONFIGURATION
-------------

Add the following to your collectd.conf:

	<LoadPlugin "perl">
		Globals true
	</LoadPlugin>

	<Plugin "perl">
	  BaseName "Collectd::Plugins"
	  LoadPlugin "Graphite"

		<Plugin "Graphite">
		  Buffer "256000"
		  Prefix "servers"
		  Host   "graphite.example.com"
		  Port   "2003"
		</Plugin>
	</Plugin>


NETWORK TRAFFIC
---------------

Metrics are stored in an 8KB buffer before being
sent to graphite in order to take reduce network
overhead. The buffer size is configurable in the
config file.

Data is sent to graphite on a "best effort" 
basis. If the graphite server is down or the tcp 
connection fails, you will lose that buffer's worth
of data.
 

GRAPHITE PATHS
--------------

Graphite paths are constructed according to Collectd's standard
serialized form, eg:

	prefix.host_name.plugin[-plugin_instance].type[-type_instance].metric_name

Examples of valid paths:

	collectd.host1_example_com.cpu-0.cpu-idle.value
	collectd.host2_example_com.disk-sda.disk_octets.read
	collectd.host3_example_com.load.load.shortterm
	collectd.host3_example_com.interface.if_octets-eth0.rx

The default prefix is 'collectd'.  This can be changed in the 
collectd config file.

See here for more information on collectd plugin naming:

    http://collectd.org/wiki/index.php/Naming_schema#Plugin_instance_and_type_instance


SUPPORT AND DOCUMENTATION
-------------------------

After installing, you can find documentation for this module with the
perldoc command.

    perldoc Collectd::Plugins::Graphite

You can also look for information on the github page:

	https://github.com/joemiller/collectd-graphite

Please use the github issues page for bugs and feedback. Pull
requests are also welcome!

	https://github.com/joemiller/collectd-graphite/issues

You can also check the syslog (/var/log/syslog) where the plugin 
will log any unsuccessful attempts to connect to your Graphite server.

Changelog
---------
See the Changes file.

FUTURE?
-------

- write tests!!
- Support sending data to graphite via AMQP
- Re-write in C if collectd-perl interface proves problematic


LICENSE AND COPYRIGHT
---------------------

Copyright 2011 Joe Miller.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
