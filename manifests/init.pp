# Class: jenkins4php
#
# This module manages jenkins4php
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class jenkins4php {
	include jenkins
	include jenkins4php::plugins
	include jenkins4php::templatejob
	
	package { "java-1.6.0-openjdk":
		ensure => installed
	}

	Package['java-1.6.0-openjdk'] -> Class['Jenkins'] -> Class['jenkins4php::plugins'] -> Class['jenkins4php::templatejob']
}

class jenkins4php::plugins inherits jenkins {
    # Jenkins plugins
    install-jenkins-plugin {
    	"git-plugin" :
    		name => "git";
    }
    
    install-jenkins-plugin {
    	"checkstyle" :
    		name => "checkstyle";
    }
    
    install-jenkins-plugin {
    	"cobertura" :
    		name => "cobertura";
    }
    
    install-jenkins-plugin {
        "cloverphp" :
            name => "cloverphp";
    }
    
    install-jenkins-plugin {
        "dry" :
            name => "dry";
    }
    
    install-jenkins-plugin {
        "htmlpublisher" :
            name => "htmlpublisher";
    }
    
    install-jenkins-plugin {
        "jdepend" :
            name => "jdepend";
    }
    
    install-jenkins-plugin {
        "plot" :
            name => "plot";
    }
    
    install-jenkins-plugin {
        "pmd" :
            name => "pmd";
    }
    
    install-jenkins-plugin {
        "violations" :
            name => "violations";
    }
    
    install-jenkins-plugin {
        "xunit" :
            name => "xunit";
    }
}

class jenkins4php::templatejob {
	$jenkins_dir = '/var/lib/jenkins'
	File {
		owner => "jenkins",
		group => "jenkins",
		ensure => directory
	}
	file { "${jenkins_dir}/jobs": }
	file { "${jenkins_dir}/jobs/php-template": }
	file { "${jenkins_dir}/jobs/php-template/config.xml":
		source => "puppet:///modules/jenkins4php/php-template/config.xml"
	}
	file { "${jenkins_dir}/jobs/php-template/LICENSE":
		source => "puppet:///modules/jenkins4php/php-template/LICENSE"
	}
	exec {
		"java -jar jenkins-cli.jar -s http://localhost:8080 reload-configuration":
		path => "/usr/bin",
		cwd => "${jenkins_dir}/war/WEB-INF",
		require => File["${jenkins_dir}/jobs/php-template/config.xml"]
	}
}

include phpqatools
include jenkins4php

Class["phpqatools"] -> Class["jenkins4php"]