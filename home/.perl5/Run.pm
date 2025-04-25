package Run;

use strict;
use Exporter qw(import);
use IPC::Open3;
use Symbol 'gensym';

our @EXPORT_OK = qw(shell);

# Run shell command and capture stdout, stderr and status
#
# Arguments:
# - cmd         string (required)
# - die message string (optional)
#
# If die message is given, dies with message and stderr if process exits > 0
#
# Example:
#   my $result = shell "ls /tmp/non-existent";
#   shell "ls /tmp/non-existent" "command failed";
#
sub shell {
    my ( $cmd, $error_msg ) = @_;

    my $err = gensym;
    my $pid = open3( my $in, my $out, $err, $cmd );
    close $in;

    my @stdout = <$out>;
    my @stderr = <$err>;
    chomp(@stdout);
    chomp(@stderr);

    waitpid( $pid, 0 );

    if ( $? != 0 && defined $error_msg ) {
        die "${error_msg}:\n\t" . join( "\n\t", @stderr ) if @stderr;
    }

    return {
        stodut => \@stdout,
        stderr => \@stderr,
        status => $? >> 8,
        ok     => $? == 0,
    };
}

1;
