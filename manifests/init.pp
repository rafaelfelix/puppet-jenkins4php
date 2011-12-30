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
	include phpqatools
	include java
	include jenkins
	
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
    
    install-jenkins-plugin {
        "build-pipeline-plugin" :
            name => "build-pipeline-plugin";
    }

	# PHP Template Job (see: http://jenkins-php.org/)
	$jenkins_dir = '/var/lib/jenkins'
	file { "${jenkins_dir}/jobs":
		owner => "jenkins",
		group => "jenkins",
		ensure => directory 
	}
	file { "${jenkins_dir}/jobs/php-template":
		owner => "jenkins",
		group => "jenkins",
		ensure => directory
	}
	file { "${jenkins_dir}/jobs/php-template/config.xml":
		owner => "jenkins",
		group => "jenkins",
		source => "puppet:///modules/jenkins4php/php-template/config.xml"
	}
	file { "${jenkins_dir}/jobs/php-template/LICENSE":
		owner => "jenkins",
		group => "jenkins",
		source => "puppet:///modules/jenkins4php/php-template/LICENSE"
	}
	exec {
		"java -jar jenkins-cli.jar -s http://localhost:8080 reload-configuration":
		path => "/usr/bin",
		cwd => "${jenkins_dir}/war/WEB-INF",
		require => File["${jenkins_dir}/jobs/php-template/config.xml"]
	}
	
	Class['java'] -> Class['jenkins::repo'] -> Class['jenkins::package'] -> Class['jenkins::service'] -> Class['phpqatools'] -> Class['jenkins4php']
}